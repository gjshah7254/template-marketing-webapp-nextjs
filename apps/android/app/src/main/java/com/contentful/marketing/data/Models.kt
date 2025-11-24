package com.contentful.marketing.data

import com.contentful.java.cda.CDAEntry
import com.contentful.java.cda.CDAAsset

data class Page(
    val id: String,
    val slug: String?,
    val pageName: String?,
    val topSection: List<Component>?,
    val pageContent: Component?,
    val extraSection: List<Component>?
) {
    companion object {
        fun fromEntry(entry: CDAEntry): Page {
            return Page(
                id = entry.id(),
                slug = entry.getField("slug") as? String,
                pageName = entry.getField("pageName") as? String,
                topSection = (entry.getField("topSection") as? List<*>)?.mapNotNull { 
                    (it as? CDAEntry)?.let { Component.fromEntry(it) }
                },
                pageContent = (entry.getField("pageContent") as? CDAEntry)?.let { 
                    Component.fromEntry(it) 
                },
                extraSection = (entry.getField("extraSection") as? List<*>)?.mapNotNull { 
                    (it as? CDAEntry)?.let { Component.fromEntry(it) }
                }
            )
        }
    }
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

    companion object {
        fun fromEntry(entry: CDAEntry): Component? {
            val contentType = entry.contentType()?.id() ?: return null
            
            return when (contentType) {
                "componentHeroBanner" -> HeroBanner(
                    id = entry.id(),
                    headline = entry.getField("headline") as? String,
                    subline = entry.getField("subline") as? String,
                    ctaText = entry.getField("ctaText") as? String,
                    imageUrl = (entry.getField("image") as? CDAAsset)?.url(),
                    colorPalette = entry.getField("colorPalette") as? String
                )
                "componentCta" -> CTA(
                    id = entry.id(),
                    headline = entry.getField("headline") as? String,
                    subline = entry.getField("subline") as? String,
                    ctaText = entry.getField("ctaText") as? String,
                    colorPalette = entry.getField("colorPalette") as? String
                )
                "componentTextBlock" -> TextBlock(
                    id = entry.id(),
                    headline = entry.getField("headline") as? String,
                    bodyText = entry.getField("bodyText") as? String,
                    colorPalette = entry.getField("colorPalette") as? String
                )
                "componentInfoBlock" -> InfoBlock(
                    id = entry.id(),
                    headline = entry.getField("headline") as? String,
                    bodyText = entry.getField("bodyText") as? String,
                    imageUrl = (entry.getField("image") as? CDAAsset)?.url(),
                    colorPalette = entry.getField("colorPalette") as? String
                )
                "componentDuplex" -> Duplex(
                    id = entry.id(),
                    headline = entry.getField("headline") as? String,
                    bodyText = entry.getField("bodyText") as? String,
                    imageUrl = (entry.getField("image") as? CDAAsset)?.url(),
                    imagePosition = entry.getField("imagePosition") as? String,
                    colorPalette = entry.getField("colorPalette") as? String
                )
                "componentQuote" -> Quote(
                    id = entry.id(),
                    quoteText = entry.getField("quoteText") as? String,
                    authorName = entry.getField("authorName") as? String,
                    authorTitle = entry.getField("authorTitle") as? String,
                    authorImageUrl = (entry.getField("authorImage") as? CDAAsset)?.url(),
                    colorPalette = entry.getField("colorPalette") as? String
                )
                else -> null
            }
        }
    }
}

data class Navigation(
    val id: String,
    val menuItems: List<MenuGroup>?
) {
    companion object {
        fun fromEntry(entry: CDAEntry): Navigation {
            return Navigation(
                id = entry.id(),
                menuItems = (entry.getField("menuItems") as? List<*>)?.mapNotNull { 
                    (it as? CDAEntry)?.let { MenuGroup.fromEntry(it) }
                }
            )
        }
    }
}

data class MenuGroup(
    val id: String,
    val groupName: String?,
    val menuItems: List<MenuItem>?
) {
    companion object {
        fun fromEntry(entry: CDAEntry): MenuGroup {
            return MenuGroup(
                id = entry.id(),
                groupName = entry.getField("groupName") as? String,
                menuItems = (entry.getField("menuItems") as? List<*>)?.mapNotNull { 
                    (it as? CDAEntry)?.let { MenuItem.fromEntry(it) }
                }
            )
        }
    }
}

data class MenuItem(
    val id: String,
    val label: String?,
    val path: String?,
    val externalLink: String?
) {
    companion object {
        fun fromEntry(entry: CDAEntry): MenuItem {
            return MenuItem(
                id = entry.id(),
                label = entry.getField("label") as? String,
                path = entry.getField("path") as? String,
                externalLink = entry.getField("externalLink") as? String
            )
        }
    }
}

data class Footer(
    val id: String,
    val logoUrl: String?,
    val menuItems: List<MenuGroup>?,
    val copyrightText: String?
) {
    companion object {
        fun fromEntry(entry: CDAEntry): Footer {
            return Footer(
                id = entry.id(),
                logoUrl = (entry.getField("logo") as? CDAAsset)?.url(),
                menuItems = (entry.getField("menuItems") as? List<*>)?.mapNotNull { 
                    (it as? CDAEntry)?.let { MenuGroup.fromEntry(it) }
                },
                copyrightText = entry.getField("copyrightText") as? String
            )
        }
    }
}

