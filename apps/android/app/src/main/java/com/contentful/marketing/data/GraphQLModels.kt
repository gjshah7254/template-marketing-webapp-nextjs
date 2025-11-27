package com.contentful.marketing.data

// GraphQL response models
data class GraphQLPage(
    val sys: GraphQLSys,
    val slug: String?,
    val pageName: String?,
    val topSectionCollection: GraphQLCollection<GraphQLComponent>?,
    val pageContent: GraphQLComponent?,
    val extraSectionCollection: GraphQLCollection<GraphQLComponent>?
)

data class GraphQLNavigationMenu(
    val menuItemsCollection: GraphQLCollection<GraphQLMenuGroup>?
)

data class GraphQLNavigationMenuCollection(
    val items: List<GraphQLNavigationMenu>
)

data class GraphQLFooterMenu(
    val sys: GraphQLSys,
    val menuItemsCollection: GraphQLCollection<GraphQLFooterMenuGroup>?,
    val legalLinks: GraphQLLegalLinks?,
    val twitterLink: String?,
    val facebookLink: String?,
    val linkedinLink: String?,
    val instagramLink: String?
)

data class GraphQLFooterMenuCollection(
    val items: List<GraphQLFooterMenu>
)

data class GraphQLFooterMenuGroup(
    val sys: GraphQLSys,
    val groupName: String?,
    val featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
)

data class GraphQLLegalLinks(
    val featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
)

data class GraphQLSys(
    val id: String
)

data class GraphQLCollection<T>(
    val items: List<T>
)

data class GraphQLComponent(
    val __typename: String?,
    val sys: GraphQLSys?,
    val headline: String? = null,
    val subline: String? = null,
    val ctaText: String? = null,
    val image: GraphQLAsset? = null,
    val colorPalette: String? = null,
    val bodyText: GraphQLRichText? = null,
    val imagePosition: String? = null,
    val quoteText: String? = null,
    val authorName: String? = null,
    val authorTitle: String? = null,
    val authorImage: GraphQLAsset? = null
)

data class GraphQLMenuGroup(
    val sys: GraphQLSys,
    val groupName: String?,
    val groupLink: GraphQLPageLink?,
    val featuredPagesCollection: GraphQLCollection<GraphQLPageLink>?
)

data class GraphQLPageLink(
    val __typename: String? = null, // Optional since it's queried but may not always be present
    val sys: GraphQLSys,
    val slug: String?,
    val pageName: String?
)

data class GraphQLMenuItem(
    val sys: GraphQLSys,
    val label: String?,
    val path: String?,
    val externalLink: String?
)

data class GraphQLAsset(
    val url: String?
)

data class GraphQLRichText(
    val json: Map<String, Any>?
)

// Extension functions to convert GraphQL models to app models
fun Page.Companion.fromGraphQL(graphQLPage: GraphQLPage): Page {
    return Page(
        id = graphQLPage.sys.id,
        slug = graphQLPage.slug,
        pageName = graphQLPage.pageName,
        topSection = graphQLPage.topSectionCollection?.items?.mapNotNull { 
            Component.fromGraphQL(it) 
        },
        pageContent = graphQLPage.pageContent?.let { Component.fromGraphQL(it) },
        extraSection = graphQLPage.extraSectionCollection?.items?.mapNotNull { 
            Component.fromGraphQL(it) 
        }
    )
}

fun Component.Companion.fromGraphQL(component: GraphQLComponent): Component? {
    val typename = component.__typename ?: return null
    val id = component.sys?.id ?: return null
    
    return when (typename) {
        "ComponentHeroBanner" -> Component.HeroBanner(
            id = id,
            headline = component.headline,
            subline = component.subline,
            ctaText = component.ctaText,
            imageUrl = component.image?.url,
            colorPalette = component.colorPalette
        )
        "ComponentCta" -> Component.CTA(
            id = id,
            headline = component.headline,
            subline = component.subline,
            ctaText = component.ctaText,
            colorPalette = component.colorPalette
        )
        "ComponentTextBlock" -> Component.TextBlock(
            id = id,
            headline = component.headline,
            bodyText = component.bodyText?.json?.toString(), // Simplified - you may want to parse rich text properly
            colorPalette = component.colorPalette
        )
        "ComponentInfoBlock" -> Component.InfoBlock(
            id = id,
            headline = component.headline,
            bodyText = component.bodyText?.json?.toString(),
            imageUrl = component.image?.url,
            colorPalette = component.colorPalette
        )
        "ComponentDuplex" -> Component.Duplex(
            id = id,
            headline = component.headline,
            bodyText = component.bodyText?.json?.toString(),
            imageUrl = component.image?.url,
            imagePosition = component.imagePosition,
            colorPalette = component.colorPalette
        )
        "ComponentQuote" -> Component.Quote(
            id = id,
            quoteText = component.quoteText,
            authorName = component.authorName,
            authorTitle = component.authorTitle,
            authorImageUrl = component.authorImage?.url,
            colorPalette = component.colorPalette
        )
        else -> null
    }
}

fun Navigation.Companion.fromGraphQL(nav: GraphQLNavigationMenu): Navigation {
    return Navigation(
        id = "", // NavigationMenu doesn't have sys.id in the query
        menuItems = nav.menuItemsCollection?.items?.map { 
            MenuGroup.fromGraphQL(it) 
        }
    )
}

fun MenuGroup.Companion.fromGraphQL(group: GraphQLMenuGroup): MenuGroup {
    return MenuGroup(
        id = group.sys.id,
        groupName = group.groupName,
        link = group.groupLink?.let { 
            MenuItem(
                id = it.sys.id,
                label = it.pageName,
                path = it.slug,
                externalLink = null
            )
        },
        menuItems = group.featuredPagesCollection?.items?.map { pageLink ->
            MenuItem(
                id = pageLink.sys.id,
                label = pageLink.pageName,
                path = pageLink.slug,
                externalLink = null
            )
        }
    )
}

fun MenuItem.Companion.fromGraphQL(item: GraphQLMenuItem): MenuItem {
    return MenuItem(
        id = item.sys.id,
        label = item.label,
        path = item.path,
        externalLink = item.externalLink
    )
}

fun Footer.Companion.fromGraphQL(footer: GraphQLFooterMenu): Footer {
    return Footer(
        id = footer.sys.id,
        menuItems = footer.menuItemsCollection?.items?.map { group ->
            FooterMenuGroup(
                id = group.sys.id,
                groupName = group.groupName,
                menuItems = group.featuredPagesCollection?.items?.map { pageLink ->
                    MenuItem(
                        id = pageLink.sys.id,
                        label = pageLink.pageName,
                        path = pageLink.slug,
                        externalLink = null
                    )
                }
            )
        },
        legalLinks = footer.legalLinks?.featuredPagesCollection?.items?.map { pageLink ->
            MenuItem(
                id = pageLink.sys.id,
                label = pageLink.pageName,
                path = pageLink.slug,
                externalLink = null
            )
        },
        twitterLink = footer.twitterLink,
        facebookLink = footer.facebookLink,
        linkedinLink = footer.linkedinLink,
        instagramLink = footer.instagramLink
    )
}

