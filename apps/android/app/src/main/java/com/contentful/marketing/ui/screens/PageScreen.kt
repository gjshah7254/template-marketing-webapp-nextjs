package com.contentful.marketing.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.contentful.marketing.data.ContentfulService
import com.contentful.marketing.data.Page
import com.contentful.marketing.ui.components.ComponentView
import kotlinx.coroutines.launch

@Composable
fun PageScreen(slug: String, navController: NavController) {
    val contentfulService = remember { ContentfulService() }
    var page by remember { mutableStateOf<Page?>(null) }
    var isLoading by remember { mutableStateOf(true) }
    var error by remember { mutableStateOf<String?>(null) }
    val scope = rememberCoroutineScope()

    LaunchedEffect(slug) {
        scope.launch {
            try {
                isLoading = true
                page = contentfulService.fetchPage(slug)
                error = null
            } catch (e: Exception) {
                error = e.message
            } finally {
                isLoading = false
            }
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
    ) {
        when {
            isLoading -> {
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    CircularProgressIndicator()
                }
            }
            error != null -> {
                ErrorView(error = error!!) {
                    scope.launch {
                        try {
                            isLoading = true
                            page = contentfulService.fetchPage(slug)
                            error = null
                        } catch (e: Exception) {
                            error = e.message
                        } finally {
                            isLoading = false
                        }
                    }
                }
            }
            page != null -> {
                PageView(page = page!!, navController = navController)
            }
        }
    }
}

