package com.contentful.marketing.ui.screens

import android.util.Log
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
import com.contentful.marketing.data.Footer
import com.contentful.marketing.data.Navigation
import com.contentful.marketing.data.Page
import com.contentful.marketing.ui.components.ComponentView
import com.contentful.marketing.ui.components.FooterView
import com.contentful.marketing.ui.components.Header
import com.contentful.marketing.ui.components.MobileMenu
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(navController: NavController) {
    val contentfulService = remember { ContentfulService() }
    var page by remember { mutableStateOf<Page?>(null) }
    var navigation by remember { mutableStateOf<Navigation?>(null) }
    var footer by remember { mutableStateOf<Footer?>(null) }
    var isLoading by remember { mutableStateOf(true) }
    var error by remember { mutableStateOf<String?>(null) }
    var isMenuOpen by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()

    LaunchedEffect(Unit) {
        scope.launch {
            try {
                isLoading = true
                error = null
                val fetchedPage = contentfulService.fetchHomePage()
                val fetchedNavigation = contentfulService.fetchNavigation()
                val fetchedFooter = contentfulService.fetchFooter()
                if (fetchedPage == null) {
                    error = "No page data returned. Please check your Contentful configuration."
                } else {
                    page = fetchedPage
                }
                navigation = fetchedNavigation
                footer = fetchedFooter
            } catch (e: Exception) {
                error = e.message ?: "Unknown error occurred: ${e.javaClass.simpleName}"
                Log.e("HomeScreen", "Error fetching page", e)
            } finally {
                isLoading = false
            }
        }
    }

    Scaffold(
        topBar = {
            Header(onMenuClick = { isMenuOpen = !isMenuOpen })
        }
    ) { paddingValues ->
        Box(modifier = Modifier.padding(paddingValues)) {
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
            else -> {
                // Fallback UI when page is null and no error (e.g., empty credentials)
                Box(
                    modifier = Modifier.fillMaxSize(),
                    contentAlignment = Alignment.Center
                ) {
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        modifier = Modifier.padding(16.dp)
                    ) {
                        Text(
                            text = "No Content Available",
                            style = MaterialTheme.typography.headlineSmall
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Please configure Contentful credentials in gradle.properties",
                            style = MaterialTheme.typography.bodyMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                        Spacer(modifier = Modifier.height(16.dp))
                        Button(onClick = {
                            scope.launch {
                                try {
                                    isLoading = true
                                    page = contentfulService.fetchHomePage()
                                    error = null
                                } catch (e: Exception) {
                                    error = e.message ?: "Unknown error"
                                } finally {
                                    isLoading = false
                                }
                            }
                        }) {
                            Text("Retry")
                        }
                    }
                }
            }
                }
                
                // Footer - always show at bottom if available
                if (page != null && !isLoading && error == null) {
                    FooterView(
                        footer = footer,
                        navController = navController
                    )
                }
            }
            
            // Mobile Menu
            MobileMenu(
                isOpen = isMenuOpen,
                onDismiss = { isMenuOpen = false },
                menuGroups = navigation?.menuItems,
                navController = navController
            )
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

