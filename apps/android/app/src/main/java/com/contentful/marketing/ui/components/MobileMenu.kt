package com.contentful.marketing.ui.components

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import androidx.navigation.NavController
import com.contentful.marketing.data.MenuGroup
import com.contentful.marketing.data.MenuItem

@Composable
fun MobileMenu(
    isOpen: Boolean,
    onDismiss: () -> Unit,
    menuGroups: List<MenuGroup>?,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    val configuration = LocalConfiguration.current
    val density = LocalDensity.current
    val screenWidthPx = with(density) { configuration.screenWidthDp.dp.toPx() }
    val drawerWidthPx = screenWidthPx * 0.7f
    
    val offsetX by animateFloatAsState(
        targetValue = if (isOpen) 0f else drawerWidthPx,
        animationSpec = tween(durationMillis = 300),
        label = "drawer_offset"
    )
    
    if (isOpen || offsetX < drawerWidthPx) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .zIndex(1000f)
        ) {
            // Backdrop - clickable overlay to close menu
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .background(Color.Black.copy(alpha = if (isOpen) 0.3f else 0f))
                    .clickable(enabled = isOpen) { onDismiss() }
            )
            
            // Drawer - aligned to right, takes about 1/3 of screen width
            Box(
                modifier = modifier
                    .fillMaxHeight()
                    .width(with(density) { drawerWidthPx.toDp() })
                    .align(Alignment.CenterEnd)
                    .offset(x = with(density) { offsetX.toDp() })
                    .background(Color.White)
                    .zIndex(1001f)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxHeight()
                        .verticalScroll(rememberScrollState())
                        .padding(horizontal = 32.dp, vertical = 16.dp)
                ) {
                    menuGroups?.forEach { menuGroup ->
                        // If menuGroup has a link, make it clickable (like Next.js)
                        if (menuGroup.link != null) {
                            MenuItemText(
                                text = menuGroup.groupName ?: "",
                                onClick = {
                                    menuGroup.link?.path?.let { path ->
                                        val cleanPath = if (path.startsWith("/")) {
                                            path.removePrefix("/")
                                        } else {
                                            path
                                        }
                                        navController.navigate("page/$cleanPath")
                                    }
                                    onDismiss()
                                },
                                isHeader = false
                            )
                        } else if (!menuGroup.menuItems.isNullOrEmpty()) {
                            // If has children but no link, show as header with submenu
                            MenuItemText(
                                text = menuGroup.groupName ?: "",
                                onClick = {},
                                isHeader = true
                            )
                            
                            // Menu items as submenu (with left border)
                            menuGroup.menuItems?.forEach { menuItem ->
                                MenuItemText(
                                    text = menuItem.label ?: "",
                                    onClick = {
                                        menuItem.path?.let { path ->
                                            val cleanPath = if (path.startsWith("/")) {
                                                path.removePrefix("/")
                                            } else {
                                                path
                                            }
                                            navController.navigate("page/$cleanPath")
                                        } ?: menuItem.externalLink?.let { externalLink ->
                                            // Handle external link if needed
                                        }
                                        onDismiss()
                                    },
                                    isHeader = false,
                                    isSubmenu = true
                                )
                            }
                        } else {
                            // Fallback: just show group name (non-clickable)
                            MenuItemText(
                                text = menuGroup.groupName ?: "",
                                onClick = {},
                                isHeader = true
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun MenuItemText(
    text: String,
    onClick: () -> Unit,
    isHeader: Boolean,
    isSubmenu: Boolean = false,
    modifier: Modifier = Modifier
) {
    val textColor = MaterialTheme.colorScheme.onSurface
    
    val fontSize = 21.sp
    val lineHeight = 1.8f
    
    Box(
        modifier = modifier
            .fillMaxWidth()
            .padding(
                vertical = if (isSubmenu) 8.dp else 12.dp,
                horizontal = 0.dp
            )
            .then(
                if (!isHeader) {
                    Modifier.clickable { onClick() }
                } else {
                    Modifier
                }
            )
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Left border for submenu items
            if (isSubmenu) {
                Spacer(modifier = Modifier.width(16.dp))
                Box(
                    modifier = Modifier
                        .width(1.dp)
                        .height(20.dp)
                        .background(Color(0xFFEEEEEE))
                )
                Spacer(modifier = Modifier.width(16.dp))
            }
            
            Text(
                text = text,
                fontSize = fontSize,
                lineHeight = (fontSize.value * lineHeight).sp,
                fontWeight = FontWeight.Normal,
                color = textColor,
                modifier = Modifier.weight(1f)
            )
        }
    }
}

