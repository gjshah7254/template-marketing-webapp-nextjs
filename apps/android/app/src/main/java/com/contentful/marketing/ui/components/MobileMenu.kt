package com.contentful.marketing.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.contentful.marketing.data.MenuGroup
import com.contentful.marketing.data.MenuItem

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MobileMenu(
    isOpen: Boolean,
    onDismiss: () -> Unit,
    menuGroups: List<MenuGroup>?,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    if (isOpen) {
        ModalDrawer(
            onDismissRequest = onDismiss,
            drawerContent = {
                ModalDrawerSheet(
                    modifier = modifier.width(280.dp)
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxHeight()
                            .verticalScroll(rememberScrollState())
                            .padding(horizontal = 32.dp, vertical = 16.dp)
                    ) {
                        menuGroups?.forEach { menuGroup ->
                            Spacer(modifier = Modifier.height(16.dp))
                            
                            // Menu group header
                            Text(
                                text = menuGroup.groupName ?: "",
                                fontSize = 21.sp,
                                fontWeight = FontWeight.Normal,
                                color = MaterialTheme.colorScheme.onSurface,
                                modifier = Modifier.padding(bottom = 8.dp)
                            )
                            
                            // Menu items
                            menuGroup.menuItems?.forEach { menuItem ->
                                MenuItemRow(
                                    menuItem = menuItem,
                                    navController = navController,
                                    onItemClick = onDismiss
                                )
                            }
                        }
                    }
                }
            }
        ) {
            // Empty content - drawer overlay
        }
    }
}

@Composable
fun MenuItemRow(
    menuItem: MenuItem,
    navController: NavController,
    onItemClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    TextButton(
        onClick = {
            menuItem.path?.let { path ->
                if (path.startsWith("/")) {
                    navController.navigate("page/${path.removePrefix("/")}")
                } else {
                    navController.navigate("page/$path")
                }
            } ?: menuItem.externalLink?.let { externalLink ->
                // Handle external link if needed
            }
            onItemClick()
        },
        modifier = modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
    ) {
        Text(
            text = menuItem.label ?: "",
            fontSize = 21.sp,
            fontWeight = FontWeight.Normal,
            modifier = Modifier.fillMaxWidth()
        )
    }
}

