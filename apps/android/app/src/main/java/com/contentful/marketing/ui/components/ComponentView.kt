package com.contentful.marketing.ui.components

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.ui.draw.clip
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.contentful.marketing.data.Component

@Composable
fun ComponentView(component: Component, navController: NavController) {
    when (component) {
        is Component.HeroBanner -> HeroBannerView(component)
        is Component.CTA -> CTAView(component)
        is Component.TextBlock -> TextBlockView(component)
        is Component.InfoBlock -> InfoBlockView(component)
        is Component.Duplex -> DuplexView(component)
        is Component.Quote -> QuoteView(component)
    }
}

@Composable
fun HeroBannerView(heroBanner: Component.HeroBanner) {
    Box(modifier = Modifier.fillMaxWidth()) {
        heroBanner.imageUrl?.let { imageUrl ->
            AsyncImage(
                model = imageUrl,
                contentDescription = heroBanner.headline,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(400.dp)
            )
        }
        
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            heroBanner.headline?.let {
                Text(
                    text = it,
                    style = MaterialTheme.typography.displayMedium,
                    color = MaterialTheme.colorScheme.onSurface
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            heroBanner.subline?.let {
                Text(
                    text = it,
                    style = MaterialTheme.typography.titleLarge,
                    color = MaterialTheme.colorScheme.onSurface
                )
            }
            Spacer(modifier = Modifier.height(16.dp))
            heroBanner.ctaText?.let {
                Button(onClick = { /* Handle CTA */ }) {
                    Text(it)
                }
            }
        }
    }
}

@Composable
fun CTAView(cta: Component.CTA) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalAlignment = androidx.compose.ui.Alignment.CenterHorizontally
    ) {
        cta.headline?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.headlineMedium
            )
        }
        Spacer(modifier = Modifier.height(8.dp))
        cta.subline?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurfaceVariant
            )
        }
        Spacer(modifier = Modifier.height(16.dp))
        cta.ctaText?.let {
            Button(onClick = { /* Handle CTA */ }) {
                Text(it)
            }
        }
    }
}

@Composable
fun TextBlockView(textBlock: Component.TextBlock) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        textBlock.headline?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.headlineSmall
            )
        }
        Spacer(modifier = Modifier.height(8.dp))
        textBlock.bodyText?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.bodyLarge
            )
        }
    }
}

@Composable
fun InfoBlockView(infoBlock: Component.InfoBlock) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp)
    ) {
        infoBlock.imageUrl?.let { imageUrl ->
            AsyncImage(
                model = imageUrl,
                contentDescription = infoBlock.headline,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(300.dp)
            )
            Spacer(modifier = Modifier.height(16.dp))
        }
        infoBlock.headline?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.headlineSmall
            )
        }
        Spacer(modifier = Modifier.height(8.dp))
        infoBlock.bodyText?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.bodyLarge
            )
        }
    }
}

@Composable
fun DuplexView(duplex: Component.Duplex) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        val imageFirst = duplex.imagePosition == "left"
        
        if (imageFirst) {
            duplex.imageUrl?.let { imageUrl ->
                AsyncImage(
                    model = imageUrl,
                    contentDescription = duplex.headline,
                    modifier = Modifier
                        .weight(1f)
                        .height(200.dp)
                )
            }
        }
        
        Column(modifier = Modifier.weight(1f)) {
            duplex.headline?.let {
                Text(
                    text = it,
                    style = MaterialTheme.typography.headlineSmall
                )
            }
            Spacer(modifier = Modifier.height(8.dp))
            duplex.bodyText?.let {
                Text(
                    text = it,
                    style = MaterialTheme.typography.bodyLarge
                )
            }
        }
        
        if (!imageFirst) {
            duplex.imageUrl?.let { imageUrl ->
                AsyncImage(
                    model = imageUrl,
                    contentDescription = duplex.headline,
                    modifier = Modifier
                        .weight(1f)
                        .height(200.dp)
                )
            }
        }
    }
}

@Composable
fun QuoteView(quote: Component.Quote) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        horizontalAlignment = androidx.compose.ui.Alignment.CenterHorizontally
    ) {
        quote.quoteText?.let {
            Text(
                text = it,
                style = MaterialTheme.typography.titleLarge,
                fontStyle = FontStyle.Italic
            )
        }
        Spacer(modifier = Modifier.height(16.dp))
        Row(
            horizontalArrangement = Arrangement.spacedBy(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            quote.authorImageUrl?.let { imageUrl ->
                AsyncImage(
                    model = imageUrl,
                    contentDescription = quote.authorName,
                    modifier = Modifier
                        .size(60.dp)
                        .clip(CircleShape)
                )
            }
            Column {
                quote.authorName?.let {
                    Text(
                        text = it,
                        style = MaterialTheme.typography.bodyLarge,
                        fontWeight = FontWeight.Bold
                    )
                }
                quote.authorTitle?.let {
                    Text(
                        text = it,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }
            }
        }
    }
}

