package com.contentful.marketing

import androidx.compose.runtime.Composable
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController

@Composable
fun ContentfulMarketingApp() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = "home"
    ) {
        composable("home") {
            HomeScreen(navController = navController)
        }
        composable("page/{slug}") { backStackEntry ->
            val slug = backStackEntry.arguments?.getString("slug") ?: "home"
            PageScreen(slug = slug, navController = navController)
        }
    }
}

