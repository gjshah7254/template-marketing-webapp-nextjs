package com.contentful.marketing.data

import com.contentful.java.cda.CDAClient
import com.contentful.java.cda.CDAEntry
import com.contentful.java.cda.QueryOperation
import com.contentful.marketing.BuildConfig

class ContentfulService {
    private val client: CDAClient = CDAClient.builder()
        .setSpace(BuildConfig.CONTENTFUL_SPACE_ID)
        .setToken(BuildConfig.CONTENTFUL_ACCESS_TOKEN)
        .build()

    suspend fun fetchPage(slug: String, locale: String = "en-US"): Page? {
        return try {
            val entries = client.fetch(CDAEntry::class.java)
                .where("content_type", "page")
                .where("fields.slug", QueryOperation.`is`, slug)
                .all()
            
            entries.items.firstOrNull()?.let { entry ->
                Page.fromEntry(entry)
            }
        } catch (e: Exception) {
            null
        }
    }

    suspend fun fetchNavigation(locale: String = "en-US"): Navigation? {
        return try {
            val entries = client.fetch(CDAEntry::class.java)
                .where("content_type", "navigation")
                .all()
            
            entries.items.firstOrNull()?.let { entry ->
                Navigation.fromEntry(entry)
            }
        } catch (e: Exception) {
            null
        }
    }

    suspend fun fetchFooter(locale: String = "en-US"): Footer? {
        return try {
            val entries = client.fetch(CDAEntry::class.java)
                .where("content_type", "footer")
                .all()
            
            entries.items.firstOrNull()?.let { entry ->
                Footer.fromEntry(entry)
            }
        } catch (e: Exception) {
            null
        }
    }

    suspend fun fetchHomePage(locale: String = "en-US"): Page? {
        return fetchPage("home", locale)
    }
}

