package com.contentful.marketing.data

data class Page(
    val id: String,
    val slug: String?,
    val pageName: String?,
    val topSection: List<Component>?,
    val pageContent: Component?,
    val extraSection: List<Component>?
) {
    companion object
}

sealed class Component {
    data class HeroBanner(
        val id: String,
        val headline: String?,
        val subline: String?,
        val ctaText: String?,
        val imageUrl: String?,
        val colorPalette: String?
    ) : Component()

    data class CTA(
        val id: String,
        val headline: String?,
        val subline: String?,
        val ctaText: String?,
        val colorPalette: String?
    ) : Component()

    data class TextBlock(
        val id: String,
        val headline: String?,
        val bodyText: String?,
        val colorPalette: String?
    ) : Component()

    data class InfoBlock(
        val id: String,
        val headline: String?,
        val bodyText: String?,
        val imageUrl: String?,
        val colorPalette: String?
    ) : Component()

    data class Duplex(
        val id: String,
        val headline: String?,
        val bodyText: String?,
        val imageUrl: String?,
        val imagePosition: String?,
        val colorPalette: String?
    ) : Component()

    data class Quote(
        val id: String,
        val quoteText: String?,
        val authorName: String?,
        val authorTitle: String?,
        val authorImageUrl: String?,
        val colorPalette: String?
    ) : Component()

    companion object
}

data class Navigation(
    val id: String,
    val menuItems: List<MenuGroup>?
) {
    companion object
}

data class MenuGroup(
    val id: String,
    val groupName: String?,
    val link: MenuItem?, // If present, the group name is clickable
    val menuItems: List<MenuItem>? // Children/submenu items
) {
    companion object
}

data class MenuItem(
    val id: String,
    val label: String?,
    val path: String?,
    val externalLink: String?
) {
    companion object
}

data class Footer(
    val id: String,
    val menuItems: List<FooterMenuGroup>?,
    val legalLinks: List<MenuItem>?,
    val twitterLink: String?,
    val facebookLink: String?,
    val linkedinLink: String?,
    val instagramLink: String?
) {
    companion object
}

data class FooterMenuGroup(
    val id: String,
    val groupName: String?,
    val menuItems: List<MenuItem>? // From featuredPagesCollection
) {
    companion object
}

