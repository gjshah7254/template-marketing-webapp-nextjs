package com.contentful.marketing.data

import android.util.Log
import com.contentful.marketing.BuildConfig
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.POST

// GraphQL request/response models
data class GraphQLRequest(
    val query: String,
    val variables: Map<String, Any>? = null
)

data class GraphQLResponse(
    val data: GraphQLData?,
    val errors: List<GraphQLError>? = null
)

data class GraphQLData(
    val pageCollection: PageCollection? = null,
    val navigationMenuCollection: GraphQLNavigationMenuCollection? = null,
    val footerMenuCollection: GraphQLFooterMenuCollection? = null
)

data class PageCollection(
    val items: List<GraphQLPage>
)

data class GraphQLError(
    val message: String
)

// GraphQL API interface
interface ContentfulGraphQLApi {
    @POST("content/v1/spaces/{spaceId}/environments/{environmentName}")
    suspend fun query(
        @Header("Authorization") authorization: String,
        @Header("Content-Type") contentType: String = "application/json",
        @retrofit2.http.Path("spaceId") spaceId: String,
        @retrofit2.http.Path("environmentName") environmentName: String = "master",
        @Body request: GraphQLRequest
    ): GraphQLResponse
}

class ContentfulService {
    private val api: ContentfulGraphQLApi by lazy {
        val logging = HttpLoggingInterceptor().apply {
            level = HttpLoggingInterceptor.Level.BODY
        }
        
        val client = OkHttpClient.Builder()
            .addInterceptor(logging)
            .build()
        
        val retrofit = Retrofit.Builder()
            .baseUrl("https://graphql.contentful.com/")
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        
        retrofit.create(ContentfulGraphQLApi::class.java)
    }
    
    private val authorizationHeader: String
        get() {
            val token = BuildConfig.CONTENTFUL_DELIVERY_ACCESS_TOKEN
            if (token.isBlank()) {
                throw IllegalStateException("CONTENTFUL_DELIVERY_ACCESS_TOKEN is not configured. Please set it in gradle.properties")
            }
            return "Bearer $token"
        }
    
    suspend fun fetchPage(slug: String, locale: String = "en-US"): Page? {
        return withContext(Dispatchers.IO) {
            try {
                val spaceId = BuildConfig.CONTENTFUL_SPACE_ID
                if (spaceId.isBlank()) {
                    throw IllegalStateException("CONTENTFUL_SPACE_ID is not configured. Please set it in gradle.properties")
                }
                val query = """
                    query GetPage(${'$'}slug: String!, ${'$'}locale: String!) {
                      pageCollection(where: { slug: ${'$'}slug }, locale: ${'$'}locale, limit: 1) {
                        items {
                          sys { id }
                          slug
                          pageName
                          topSectionCollection {
                            items {
                              __typename
                              ... on Entry {
                                sys { id }
                              }
                              ... on ComponentHeroBanner {
                                headline
                                bodyText { json }
                                ctaText
                                image { url }
                                imageStyle
                                colorPalette
                              }
                              ... on ComponentCta {
                                headline
                                subline: subline { json }
                                ctaText
                                colorPalette
                              }
                              ... on ComponentTextBlock {
                                headline
                                sublineText: subline
                                body { json }
                                colorPalette
                              }
                              ... on ComponentInfoBlock {
                                headline
                                sublineText: subline
                                block1Image { url }
                                block1Body { json }
                                block2Image { url }
                                block2Body { json }
                                block3Image { url }
                                block3Body { json }
                                colorPalette
                              }
                              ... on ComponentDuplex {
                                headline
                                bodyText { json }
                                image { url }
                                imageStyle
                                colorPalette
                              }
                              ... on ComponentQuote {
                                quote { json }
                                image { url }
                                imagePosition
                                colorPalette
                              }
                            }
                          }
                          pageContent {
                            __typename
                            ... on Entry {
                              sys { id }
                            }
                          }
                          extraSectionCollection {
                            items {
                              __typename
                              ... on Entry {
                                sys { id }
                              }
                              ... on ComponentHeroBanner {
                                headline
                                bodyText { json }
                                ctaText
                                image { url }
                                imageStyle
                                colorPalette
                              }
                              ... on ComponentCta {
                                headline
                                subline: subline { json }
                                ctaText
                                colorPalette
                              }
                              ... on ComponentTextBlock {
                                headline
                                sublineText: subline
                                body { json }
                                colorPalette
                              }
                              ... on ComponentInfoBlock {
                                headline
                                sublineText: subline
                                block1Image { url }
                                block1Body { json }
                                block2Image { url }
                                block2Body { json }
                                block3Image { url }
                                block3Body { json }
                                colorPalette
                              }
                              ... on ComponentDuplex {
                                headline
                                bodyText { json }
                                image { url }
                                imageStyle
                                colorPalette
                              }
                              ... on ComponentQuote {
                                quote { json }
                                image { url }
                                imagePosition
                                colorPalette
                              }
                            }
                          }
                        }
                      }
                    }
                """.trimIndent()
                
                val request = GraphQLRequest(
                    query = query,
                    variables = mapOf(
                        "slug" to slug,
                        "locale" to locale
                    )
                )
                
                val environmentName = if (BuildConfig.ENVIRONMENT_NAME.isNotBlank()) {
                    BuildConfig.ENVIRONMENT_NAME
                } else {
                    "master"
                }
                
                val response = api.query(
                    authorizationHeader, 
                    spaceId = BuildConfig.CONTENTFUL_SPACE_ID,
                    environmentName = environmentName,
                    request = request
                )
                
                if (response.errors != null && response.errors.isNotEmpty()) {
                    val errorMessage = response.errors.joinToString { it.message }
                    Log.e("ContentfulService", "GraphQL errors: $errorMessage")
                    throw Exception("Contentful API error: $errorMessage")
                }
                
                response.data?.pageCollection?.items?.firstOrNull()?.let { graphQLPage ->
                    Page.fromGraphQL(graphQLPage)
                } ?: run {
                    Log.w("ContentfulService", "No page found for slug: $slug")
                    null
                }
            } catch (e: Exception) {
                Log.e("ContentfulService", "Error fetching page: $slug", e)
                throw e // Re-throw to be caught by the caller
            }
        }
    }
    
    suspend fun fetchNavigation(locale: String = "en-US"): Navigation? {
        return withContext(Dispatchers.IO) {
            try {
                val query = """
                    query GetNavigation(${'$'}locale: String!) {
                      navigationMenuCollection(locale: ${'$'}locale, limit: 1) {
                        items {
                          menuItemsCollection {
                            items {
                              __typename
                              sys { id }
                              groupName
                              groupLink {
                                ... on Page {
                                  __typename
                                  slug
                                  sys { id }
                                  pageName
                                }
                              }
                              featuredPagesCollection {
                                items {
                                  ... on Page {
                                    __typename
                                    slug
                                  sys { id }
                                    pageName
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                """.trimIndent()
                
                val request = GraphQLRequest(
                    query = query,
                    variables = mapOf("locale" to locale)
                )
                
                val environmentName = if (BuildConfig.ENVIRONMENT_NAME.isNotBlank()) {
                    BuildConfig.ENVIRONMENT_NAME
                } else {
                    "master"
                }
                
                val response = api.query(
                    authorizationHeader, 
                    spaceId = BuildConfig.CONTENTFUL_SPACE_ID,
                    environmentName = environmentName,
                    request = request
                )
                response.data?.navigationMenuCollection?.items?.firstOrNull()?.let { graphQLNav ->
                    Navigation.fromGraphQL(graphQLNav)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }
    
    suspend fun fetchFooter(locale: String = "en-US"): Footer? {
        return withContext(Dispatchers.IO) {
            try {
                val query = """
                    query GetFooter(${'$'}locale: String!) {
                      footerMenuCollection(locale: ${'$'}locale, limit: 1) {
                        items {
                          __typename
                          sys { id }
                          menuItemsCollection {
                            items {
                              __typename
                              sys { id }
                              groupName
                              featuredPagesCollection {
                                items {
                                  ... on Page {
                                    __typename
                                    slug
                                    sys { id }
                                    pageName
                                  }
                                }
                              }
                            }
                          }
                          legalLinks {
                            featuredPagesCollection {
                              items {
                                ... on Page {
                                  __typename
                                  slug
                                  sys { id }
                                  pageName
                                }
                              }
                            }
                          }
                          twitterLink
                          facebookLink
                          linkedinLink
                          instagramLink
                        }
                      }
                    }
                """.trimIndent()
                
                val request = GraphQLRequest(
                    query = query,
                    variables = mapOf("locale" to locale)
                )
                
                val environmentName = if (BuildConfig.ENVIRONMENT_NAME.isNotBlank()) {
                    BuildConfig.ENVIRONMENT_NAME
                } else {
                    "master"
                }
                
                val response = api.query(
                    authorizationHeader, 
                    spaceId = BuildConfig.CONTENTFUL_SPACE_ID,
                    environmentName = environmentName,
                    request = request
                )
                response.data?.footerMenuCollection?.items?.firstOrNull()?.let { graphQLFooter ->
                    Footer.fromGraphQL(graphQLFooter)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                null
            }
        }
    }
    
    suspend fun fetchHomePage(locale: String = "en-US"): Page? {
        return fetchPage("home", locale)
    }
}

