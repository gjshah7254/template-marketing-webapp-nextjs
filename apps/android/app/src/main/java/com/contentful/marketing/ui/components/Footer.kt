package com.contentful.marketing.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Star
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.contentful.marketing.data.Footer
import com.contentful.marketing.data.FooterMenuGroup

@Composable
fun FooterView(
    footer: Footer?,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    if (footer == null) return
    
    Column(
        modifier = modifier
            .fillMaxWidth()
            .background(Color(0xFFF4F4F4))
            .padding(horizontal = 16.dp, vertical = 24.dp)
    ) {
        // Menu Items
        footer.menuItems?.let { menuGroups ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                menuGroups.forEach { menuGroup ->
                    FooterMenuColumn(
                        menuGroup = menuGroup,
                        navController = navController
                    )
                }
            }
        }
        
        Spacer(modifier = Modifier.height(24.dp))
        
        // Social Links and Copyright
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            // Logo placeholder
            Text(
                text = "COLORFULCOLLECTIVE",
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.onSurface
            )
            
            // Social Links
            Row(
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                footer.twitterLink?.let {
                    IconButton(onClick = { /* Handle Twitter */ }) {
                        Icon(
                            imageVector = Icons.Default.Star, // Placeholder - use actual social icons
                            contentDescription = "Twitter",
                            tint = MaterialTheme.colorScheme.onSurface
                        )
                    }
                }
                footer.facebookLink?.let {
                    IconButton(onClick = { /* Handle Facebook */ }) {
                        Icon(
                            imageVector = Icons.Default.Star,
                            contentDescription = "Facebook",
                            tint = MaterialTheme.colorScheme.onSurface
                        )
                    }
                }
                footer.linkedinLink?.let {
                    IconButton(onClick = { /* Handle LinkedIn */ }) {
                        Icon(
                            imageVector = Icons.Default.Star,
                            contentDescription = "LinkedIn",
                            tint = MaterialTheme.colorScheme.onSurface
                        )
                    }
                }
                footer.instagramLink?.let {
                    IconButton(onClick = { /* Handle Instagram */ }) {
                        Icon(
                            imageVector = Icons.Default.Star,
                            contentDescription = "Instagram",
                            tint = MaterialTheme.colorScheme.onSurface
                        )
                    }
                }
            }
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Copyright
        Text(
            text = "© Copyright ${java.util.Calendar.getInstance().get(java.util.Calendar.YEAR)}",
            fontSize = 12.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        
        // Legal Links
        footer.legalLinks?.let { legalLinks ->
            if (legalLinks.isNotEmpty()) {
                Spacer(modifier = Modifier.height(8.dp))
                Row(
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    legalLinks.forEach { legalLink ->
                        TextButton(
                            onClick = {
                                legalLink.path?.let { path ->
                                    val cleanPath = if (path.startsWith("/")) path.removePrefix("/") else path
                                    navController.navigate("page/$cleanPath")
                                }
                            }
                        ) {
                            Text(
                                text = legalLink.label ?: "",
                                fontSize = 12.sp
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun FooterMenuColumn(
    menuGroup: FooterMenuGroup,
    navController: NavController,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier.width(IntrinsicSize.Min)
    ) {
        // Group Name
        Text(
            text = menuGroup.groupName ?: "",
            fontSize = 14.sp,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.onSurface,
            modifier = Modifier.padding(bottom = 8.dp)
        )
        
        // Menu Items
        menuGroup.menuItems?.forEach { menuItem ->
            TextButton(
                onClick = {
                    menuItem.path?.let { path ->
                        val cleanPath = if (path.startsWith("/")) path.removePrefix("/") else path
                        navController.navigate("page/$cleanPath")
                    }
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text(
                    text = menuItem.label ?: "",
                    fontSize = 12.sp,
                    modifier = Modifier.fillMaxWidth(),
                    style = MaterialTheme.typography.bodySmall
                )
            }
        }
    }
}

