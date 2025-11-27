const environmentName = process.env.ENVIRONMENT_NAME || 'master';
const spaceId = String(process.env.CONTENTFUL_SPACE_ID);

export const fetchConfig = {
  endpoint: `https://graphql.contentful.com/content/v1/spaces/${spaceId}/environments/${environmentName}`,
  params: {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.CONTENTFUL_DELIVERY_ACCESS_TOKEN}`,
    },
  },
};

// Always use Delivery API (CDA) - no preview support
export function customFetcher<TData, TVariables extends { preview?: boolean | null }>(
  query: string,
  variables?: TVariables,
  options?: RequestInit['headers'],
) {
  return async (): Promise<TData> => {
    const res = await fetch(fetchConfig.endpoint as string, {
      method: 'POST',
      ...options,
      ...fetchConfig.params,
      body: JSON.stringify({ query, variables }),
    });

    const json = await res.json();

    if (json.errors) {
      const { message, extensions } = json.errors[0];
      
      // Handle Contentful link resolution errors more gracefully
      // These can occur when referenced assets/entries are unpublished or deleted
      if (message?.includes('cannot be resolved') || extensions?.code === 'UNRESOLVABLE_LINK') {
        console.warn('Contentful link resolution error:', message);
        // Return partial data if available, otherwise return empty object
        return (json.data || {}) as TData;
      }

      throw new Error(message);
    }

    return json.data;
  };
}
