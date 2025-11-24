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
fun HomeScreen(navController: NavController) {
    val contentfulService = remember { ContentfulService() }
    var page by remember { mutableStateOf<Page?>(null) }
    var isLoading by remember { mutableStateOf(true) }
    var error by remember { mutableStateOf<String?>(null) }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        scope.launch {
            try {
                isLoading = true
                page = contentfulService.fetchHomePage()
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
                            page = contentfulService.fetchHomePage()
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

@Composable
fun PageView(page: Page, navController: NavController) {
    Column(modifier = Modifier.fillMaxWidth()) {
        // Top Section
        page.topSection?.forEach { component ->
            ComponentView(component = component, navController = navController)
        }

        // Main Content
        page.pageContent?.let { component ->
            ComponentView(component = component, navController = navController)
        }

        // Extra Section
        page.extraSection?.forEach { component ->
            ComponentView(component = component, navController = navController)
        }
    }
}

@Composable
fun ErrorView(error: String, onRetry: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "Error loading content",
            style = MaterialTheme.typography.headlineSmall
        )
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            text = error,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.error
        )
        Spacer(modifier = Modifier.height(16.dp))
        Button(onClick = onRetry) {
            Text("Retry")
        }
    }
}

