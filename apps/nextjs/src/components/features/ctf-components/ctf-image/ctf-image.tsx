import { Box } from '@mui/material';
import Image, { ImageProps } from 'next/image';
import React, { useState } from 'react';

interface CtfImagePropsInterface extends Omit<ImageProps, 'layout'> {
  description?: string | null;
  showDescription?: boolean;
  /** @deprecated Use fill prop or explicit width/height instead */
  layout?: 'fill' | 'fixed' | 'intrinsic' | 'responsive';
}

export const CtfImage = ({
  src,
  description,
  showDescription = true,
  width,
  height,
  layout,
  ...rest
}: CtfImagePropsInterface) => {
  const [loaded, setLoaded] = useState(false);

  if (!src) return null;

  const blurUrl = new URL(String(src));
  blurUrl.searchParams.set('w', '100');

  // Convert legacy layout prop to Next.js 13+ Image API
  const imageProps: any = {
    onLoad: () => {
      setLoaded(true);
    },
    src,
    placeholder: 'blur',
    blurDataURL: blurUrl.toString(),
    ...rest,
  };

  // Handle layout prop migration
  if (layout === 'fill') {
    imageProps.fill = true;
    imageProps.style = { ...imageProps.style, objectFit: 'cover' };
  } else if (layout === 'responsive') {
    // For responsive, we need width and height
    if (width && height) {
      imageProps.width = width;
      imageProps.height = height;
      imageProps.style = { ...imageProps.style, width: '100%', height: 'auto' };
    } else {
      // Fallback to fill if no dimensions
      imageProps.fill = true;
      imageProps.style = { ...imageProps.style, objectFit: 'contain' };
    }
  } else if (layout === 'fixed') {
    if (width && height) {
      imageProps.width = width;
      imageProps.height = height;
    }
  } else {
    // Default: use width and height if provided
    if (width) imageProps.width = width;
    if (height) imageProps.height = height;
  }

  return (
    <Box
      component="figure"
      margin="0"
      fontSize={0}
      style={{
        transition: '300ms ease-out',
        transitionProperty: 'opacity',
        opacity: loaded ? 1 : 0,
        position: imageProps.fill ? 'relative' : 'static',
        width: imageProps.fill ? '100%' : 'auto',
        height: imageProps.fill ? '100%' : 'auto',
      }}>
      <Image {...imageProps} />
      {showDescription && description && <figcaption>{description}</figcaption>}
    </Box>
  );
};
