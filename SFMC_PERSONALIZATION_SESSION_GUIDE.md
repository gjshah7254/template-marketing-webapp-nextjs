# SFMC Personalization Session Guide
## Contentful + Vercel + Mobile Apps Architecture

---

## 1. About the CMS (Contentful)

### Current Setup
- **CMS Platform**: Contentful (Headless CMS)
- **Content Delivery**: GraphQL API
- **Content Model**: Structured content types (Pages, Components, etc.)
- **Environments**: Master environment with preview support
- **Content Types**: 
  - Pages (with sections: topSection, pageContent, extraSection)
  - Components (Hero Banner, CTA, Text Block, Info Block, Duplex, Quote, etc.)
  - Topics (Product, Business Info, Person)

### Key Characteristics
- **Headless Architecture**: Content is decoupled from presentation
- **GraphQL API**: Type-safe queries with code generation
- **Multi-channel**: Same content serves web (Next.js) and mobile apps (iOS/Android)
- **Component-based**: Content is structured as reusable components
- **Localization**: i18n support (currently en-US, de-DE)

### Content Structure
```
Page
├── topSection (ComponentCollection)
├── pageContent (ComponentReference)
└── extraSection (ComponentCollection)
```

Each component can be dynamically resolved and rendered based on its `__typename`.

---

## 2. How It Works

### Web Application (Next.js on Vercel)

**Architecture Flow:**
1. **Server-Side Rendering (SSR)**: Pages use `getServerSideProps` to fetch content
2. **GraphQL Queries**: Direct calls to Contentful GraphQL API
3. **React Query**: Data fetching and caching with hydration
4. **Component Resolution**: Dynamic component mapping based on Contentful content types
5. **Code Generation**: TypeScript types and React Query hooks auto-generated from GraphQL schema

**Key Files:**
- `src/lib/fetchConfig.ts` - Contentful API configuration
- `src/pages/[slug].tsx` - Dynamic page routing with SSR
- `src/components/shared/component-resolver.tsx` - Component resolution logic
- `src/mappings.ts` - Component type to React component mapping

**Data Flow:**
```
User Request → Next.js Server (Vercel)
  → Contentful GraphQL API
  → Fetch Page + Components
  → Prefetch all nested content
  → Hydrate React Query cache
  → Render SSR HTML
  → Client-side hydration
```

### Mobile Applications

**Current State:**
- **iOS**: Swift/SwiftUI app with Contentful Swift SDK
- **Android**: Kotlin/Jetpack Compose app with Contentful GraphQL API calls

**Planned Architecture:**
- Mobile apps will call **Vercel-hosted API endpoints** (not directly to Contentful)
- Vercel acts as a middleware layer for:
  - Personalization logic
  - A/B testing decisions
  - Content transformation
  - Caching and optimization

**Mobile Data Flow (Planned):**
```
Mobile App → Vercel API Endpoint
  → SFMC Personalization Check
  → Contentful GraphQL API (with personalization context)
  → Return personalized content JSON
  → Mobile app renders native UI
```

---

## 3. How to Anticipate Integrating with MCP Server-Side

### Approach 1: Server-Side Personalization (Recommended for SSR)

**Architecture:**
```
Next.js getServerSideProps
  → Identify User (via cookies/tokens)
  → Call SFMC MCP API (server-side)
  → Get personalization rules/segments
  → Modify Contentful GraphQL query variables
  → Fetch personalized content
  → Render personalized page
```

**Implementation Points:**
- **In `getServerSideProps`**: Before fetching from Contentful, call SFMC MCP to get:
  - User segments
  - A/B test assignments
  - Personalization rules
- **Contentful Query Modification**: Use personalization context to:
  - Filter content by segments
  - Select variant content (A/B test variants)
  - Include/exclude components based on rules
- **Component-Level Personalization**: In `ComponentResolver`, apply personalization rules to:
  - Show/hide components
  - Swap component variants
  - Modify component props

**Where User Segments Are Stored:**

1. **Primary Storage: SFMC Platform** (Source of Truth)
   - SFMC stores user profiles and segment memberships in its own system
   - Stored in Data Extensions and Segment Membership Data Model Objects
   - SFMC maintains the authoritative record of:
     - User attributes (demographics, behavior, preferences)
     - Segment memberships (which segments a user belongs to)
     - A/B test assignments (which variant a user is assigned to)
   - **Access**: Retrieved via SFMC MCP API calls

2. **Local Caching** (Performance Optimization)
   - **Option A: HTTP Cookies** (Recommended for web)
     - Store segment IDs and A/B test assignments in encrypted cookies
     - TTL: 24-48 hours (or until user action triggers re-evaluation)
     - Benefits: Fast access, works across page loads, no server-side storage needed
     - Example: `personalization: { segments: ["premium", "high-value"], abTests: { "hero-test": "B" } }`
   
   - **Option B: Server-Side Session** (If using session management)
     - Store in Redis/Memory cache keyed by session ID
     - TTL: Session duration
     - Benefits: More secure, can store more data
     - Drawbacks: Requires session management infrastructure
   
   - **Option C: In-Memory Cache** (Vercel Edge/Serverless)
     - Cache SFMC responses in Vercel's edge cache or serverless function memory
     - Key: User ID or anonymous ID
     - TTL: 5-15 minutes (shorter than cookies)
     - Benefits: Very fast, reduces SFMC API calls
     - Drawbacks: Cache is per-instance, may not persist across requests

3. **Recommended Hybrid Approach:**
   ```
   Request Flow:
   1. Extract user ID from cookie/token (or generate anonymous ID)
   2. Check local cache (cookie or in-memory) for segment assignment
   3. If cache hit and fresh (< 1 hour old) → Use cached segments
   4. If cache miss or stale → Call SFMC MCP API
   5. SFMC returns segments/assignments
   6. Store in cache (cookie + in-memory) with TTL
   7. Use segments for personalization
   ```

**User Identification Strategy:**
- **Authenticated Users**: Use user ID from JWT token or session
- **Anonymous Users**: 
  - Generate persistent anonymous ID (stored in cookie)
  - Use device fingerprinting as fallback
  - SFMC can track anonymous users and merge profiles when they authenticate

**Cache Invalidation:**
- **Time-based**: Segments expire after TTL (e.g., 1 hour)
- **Event-based**: Invalidate cache when:
  - User performs significant action (purchase, signup, etc.)
  - User explicitly requests fresh content
  - Marketing team updates segment rules in SFMC
- **Manual**: Admin can force refresh for specific users

**Benefits:**
- ✅ SEO-friendly (personalized content in initial HTML)
- ✅ Fast initial page load (with caching)
- ✅ Works with SSR/SSG
- ✅ Consistent with current architecture
- ✅ Reduces SFMC API calls (cost and latency optimization)
- ✅ SFMC remains source of truth for segment logic

**Challenges:**
- Requires user identification on server-side
- Need to balance cache freshness vs. performance
- Need to handle anonymous users
- Cache invalidation strategy needed

**Practical Implementation Example:**

```typescript
// In getServerSideProps or API route
async function getPersonalizationContext(userId: string | null, req: NextRequest) {
  // 1. Check cookie cache first
  const cachedSegments = req.cookies.get('personalization')?.value;
  if (cachedSegments) {
    const parsed = JSON.parse(cachedSegments);
    const cacheAge = Date.now() - parsed.timestamp;
    if (cacheAge < 3600000) { // 1 hour TTL
      return parsed.segments; // Use cached segments
    }
  }

  // 2. Call SFMC MCP API (if cache miss or stale)
  const sfmcResponse = await fetch('https://sfmc-mcp-api.com/personalization', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${SFMC_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      userId: userId || generateAnonymousId(req),
      context: {
        page: req.url,
        device: req.headers.get('user-agent'),
      },
    }),
  });

  const { segments, abTests } = await sfmcResponse.json();

  // 3. Store in cookie cache
  const cookieValue = JSON.stringify({
    segments,
    abTests,
    timestamp: Date.now(),
  });
  
  // Set cookie (will be set in response headers)
  // In Next.js: res.setHeader('Set-Cookie', `personalization=${cookieValue}; HttpOnly; Secure; SameSite=Strict; Max-Age=3600`)

  // 4. Also cache in-memory (optional, for serverless functions)
  // In-memoryCache.set(userId, { segments, abTests }, 900); // 15 min TTL

  return { segments, abTests };
}
```

**Storage Locations Summary:**

| Storage Location | What's Stored | TTL | Purpose |
|-----------------|---------------|-----|---------|
| **SFMC Platform** | User profiles, segment memberships, A/B test assignments | Permanent | Source of truth, segment logic |
| **HTTP Cookies** | Segment IDs, A/B test assignments (encrypted) | 1-48 hours | Fast access, cross-page persistence |
| **In-Memory Cache** | SFMC API responses | 5-15 minutes | Reduce API calls, improve latency |
| **Session Storage** | Full personalization context (if using sessions) | Session duration | Secure, server-side storage |

### Approach 2: Edge Middleware Personalization

**Architecture:**
```
Vercel Edge Middleware
  → Intercept request
  → Call SFMC MCP (at edge)
  → Inject personalization headers/context
  → Pass to Next.js
  → Use context in getServerSideProps
```

**Benefits:**
- ✅ Very fast (edge computing)
- ✅ Can personalize before reaching Next.js
- ✅ Good for geo-based personalization

**Challenges:**
- Edge function limitations
- May need to handle complex logic differently

### Approach 3: API Route Layer (For Mobile Apps)

**Architecture:**
```
Mobile App → /api/pages/[slug] (Next.js API Route)
  → Authenticate user
  → Call SFMC MCP
  → Get personalization rules
  → Fetch from Contentful (with personalization)
  → Return JSON response
```

**Implementation:**
- Create Next.js API routes: `/api/pages/[slug]`, `/api/components/[id]`
- These routes:
  1. Accept user context (user ID, device info, etc.)
  2. Call SFMC MCP to get personalization decisions
  3. Fetch personalized content from Contentful
  4. Return structured JSON for mobile apps

**Benefits:**
- ✅ Single source of truth for personalization logic
- ✅ Reusable for both web and mobile
- ✅ Can cache personalized responses
- ✅ Mobile apps get consistent experience

### Approach 4: Hybrid (Recommended)

**For Web (SSR):**
- Use Approach 1 (Server-Side Personalization in `getServerSideProps`)
- Personalization happens during SSR for SEO and performance

**For Mobile:**
- Use Approach 3 (API Route Layer)
- Mobile apps call Vercel API endpoints
- Same personalization logic, different delivery mechanism

**For Client-Side Personalization:**
- Use React Query mutations to update content
- Call SFMC MCP from client (for logged-in users)
- Update component visibility/variants dynamically

---

## 4. Ways of Working / Operational Rhythm for Personalization

### Content Creation Workflow

**Current Flow:**
1. Content team creates content in Contentful
2. Content is published
3. Next.js app fetches and displays content

**With Personalization:**
1. **Content Variants**: Create multiple variants of components in Contentful
   - Example: Hero Banner A, Hero Banner B (for A/B test)
   - Tag variants with metadata (segment, test ID, etc.)

2. **Personalization Rules in SFMC**:
   - Define rules based on user attributes
   - Map rules to Contentful content IDs/variants
   - Configure A/B test splits

3. **Content Publishing**:
   - Content team publishes variants in Contentful
   - Marketing team configures rules in SFMC
   - Rules reference Contentful content IDs

### Operational Rhythm

**Daily/Weekly:**
- Content team: Create and publish content variants
- Marketing team: Configure personalization rules in SFMC
- Developers: Monitor personalization API performance

**Sprint Planning:**
- Review personalization performance metrics
- Plan new personalization experiments
- Coordinate content variant creation with marketing campaigns

**Release Cycle:**
- Content changes: Immediate (Contentful publishes instantly)
- Personalization rules: Immediate (SFMC updates take effect immediately)
- Code changes: Follow standard release process

### Team Collaboration

**Content Team:**
- Creates content variants in Contentful
- Tags content with metadata (for personalization targeting)
- Uses Contentful preview to see personalized content

**Marketing Team:**
- Defines personalization rules in SFMC
- Sets up A/B tests
- Monitors performance and adjusts rules

**Development Team:**
- Implements personalization integration
- Ensures API performance and reliability
- Handles edge cases and fallbacks

**Key Integration Points:**
- **Contentful**: Source of truth for content
- **SFMC**: Source of truth for personalization rules
- **Vercel/Next.js**: Orchestration layer that combines both

---

## 5. A/B Testing

### A/B Testing Architecture

**Content Variants in Contentful:**
```
ComponentHeroBanner (Base)
├── Variant A (sys.id: "hero-variant-a")
├── Variant B (sys.id: "hero-variant-b")
└── Variant C (sys.id: "hero-variant-c")
```

**SFMC A/B Test Configuration:**
- Test ID: `hero-banner-test-2024`
- Variants: 
  - A: 33% (Contentful ID: "hero-variant-a")
  - B: 33% (Contentful ID: "hero-variant-b")
  - C: 34% (Contentful ID: "hero-variant-c")
- Duration: 2 weeks
- Success Metric: Click-through rate

### Implementation Flow

**Server-Side (Next.js):**
1. User requests page
2. `getServerSideProps` calls SFMC MCP: `getABTestVariant(userId, 'hero-banner-test-2024')`
3. SFMC returns: `{ variant: 'B', testId: 'hero-banner-test-2024' }`
4. Contentful query includes variant filter or fetches specific variant ID
5. Render variant B

**Mobile Apps:**
1. Mobile app calls `/api/pages/home`
2. API route calls SFMC MCP for A/B test assignment
3. Returns personalized content JSON with variant B
4. Mobile app renders variant B

### A/B Testing Best Practices

**Content Preparation:**
- Create all variants in Contentful before test starts
- Use consistent naming: `{component-name}-variant-{letter}`
- Tag variants with test metadata

**Test Management:**
- Use SFMC for test assignment (ensures consistent assignment)
- Store test assignments in user profile (for consistency)
- Support test preview mode (for QA/testing)

**Analytics:**
- Track variant views and conversions
- Send events to SFMC for analysis
- Use SFMC's built-in A/B test reporting

**Fallback Strategy:**
- If SFMC is unavailable, use default variant
- Log errors for monitoring
- Don't break user experience

---

## 6. Mobile App Considerations

### Current Mobile Architecture

**iOS:**
- Swift/SwiftUI
- Direct Contentful GraphQL API calls (currently)
- Native UI rendering

**Android:**
- Kotlin/Jetpack Compose
- Direct Contentful GraphQL API calls (currently)
- Native UI rendering

### Personalization for Mobile

**Recommended Approach:**
1. **API-First**: Mobile apps call Vercel API endpoints (not Contentful directly)
2. **Consistent Logic**: Same personalization logic as web (in Vercel API routes)
3. **User Context**: Mobile apps send:
   - User ID (if authenticated)
   - Device info
   - App version
   - Previous interaction data

**API Endpoints Needed:**
```
GET /api/mobile/pages/{slug}
  Query params: userId, locale, deviceType
  Returns: Personalized page JSON

GET /api/mobile/components/{id}
  Query params: userId, personalizationContext
  Returns: Personalized component JSON
```

**Mobile-Specific Considerations:**
- **Offline Support**: Cache personalized content locally
- **Performance**: Minimize API calls, batch requests
- **Push Notifications**: Can trigger personalization updates
- **Deep Linking**: Personalize based on link context

**Potential Challenges:**
- ✅ **SFMC Mobile SDK**: Can be integrated directly in mobile apps for client-side personalization
- ✅ **Hybrid Approach**: Use Vercel API for content, SFMC SDK for real-time personalization
- ⚠️ **User Identification**: Need consistent user ID across web and mobile
- ⚠️ **Session Management**: Handle anonymous vs. authenticated users

---

## 7. Technical Implementation Considerations

### User Identification

**Web:**
- Cookies for anonymous users
- JWT tokens for authenticated users
- Session management

**Mobile:**
- Device ID for anonymous users
- User ID for authenticated users
- Consistent identifier across platforms

### Caching Strategy

**Personalization Decisions:**
- Cache SFMC responses (with TTL)
- Invalidate on user action
- Edge caching for anonymous users

**Content:**
- Cache Contentful responses
- Invalidate on content publish
- CDN caching for static variants

### Performance

**Optimizations:**
- Parallel API calls (SFMC + Contentful)
- Request batching
- Edge caching
- Lazy loading for below-fold content

**Monitoring:**
- API response times
- Personalization decision latency
- Error rates
- Cache hit rates

### Error Handling

**Fallback Strategy:**
- If SFMC unavailable → use default content
- If Contentful unavailable → show cached content
- If personalization fails → degrade gracefully
- Log all errors for monitoring

---

## 8. Questions to Discuss with SFMC Team

1. **MCP API Details:**
   - What is the exact API endpoint for personalization decisions?
   - Authentication mechanism?
   - Rate limits?
   - Response format?

2. **User Context:**
   - What user attributes does SFMC need?
   - How to handle anonymous users?
   - User ID format requirements?

3. **A/B Testing:**
   - How are test assignments made?
   - Can we preview test variants?
   - How to handle test completion/analysis?

4. **Mobile Integration:**
   - Should mobile apps use SFMC SDK directly or via Vercel API?
   - Any mobile-specific considerations?
   - Push notification integration?

5. **Performance:**
   - Expected API latency?
   - Caching recommendations?
   - Edge computing support?

6. **Operational:**
   - How to manage personalization rules?
   - Content variant tagging strategy?
   - Analytics and reporting?

---

## 9. Next Steps (Post-Session)

1. **Technical Spike:**
   - Implement proof-of-concept SFMC MCP integration
   - Test with one component (e.g., Hero Banner)
   - Measure performance impact

2. **Content Strategy:**
   - Define content variant structure in Contentful
   - Create tagging/metadata strategy
   - Plan first A/B test

3. **Mobile API Design:**
   - Design API endpoints for mobile apps
   - Define request/response schemas
   - Plan migration from direct Contentful calls

4. **Monitoring Setup:**
   - Set up error tracking
   - Configure performance monitoring
   - Plan analytics integration

---

## Summary

**Architecture:**
- Contentful = Content source
- SFMC = Personalization rules engine
- Vercel/Next.js = Orchestration layer
- Mobile apps = Consume personalized content via Vercel APIs

**Key Integration Point:**
Server-side personalization in Next.js `getServerSideProps` and API routes, calling SFMC MCP before fetching from Contentful.

**Benefits:**
- SEO-friendly personalized content
- Consistent personalization across web and mobile
- Content team works in familiar Contentful interface
- Marketing team manages rules in SFMC

**Mobile Compatibility:**
✅ All approaches work with mobile apps via API layer
✅ SFMC Mobile SDK can complement server-side personalization
✅ Consistent user experience across platforms

