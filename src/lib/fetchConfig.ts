const environmentName = process.env.ENVIRONMENT_NAME || 'master';
const spaceId = String(process.env.CONTENTFUL_SPACE_ID);

export const fetchConfig = {
  endpoint: `https://graphql.contentful.com/content/v1/spaces/${spaceId}/environments/${environmentName}`,
  params: {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.CONTENTFUL_ACCESS_TOKEN}`,
    },
  },
  previewParams: {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${process.env.CONTENTFUL_PREVIEW_ACCESS_TOKEN}`,
    },
  },
};

export function customFetcher<TData, TVariables extends { preview?: boolean | null }>(
  query: string,
  variables?: TVariables,
  options?: RequestInit['headers'],
) {
  return async (): Promise<TData> => {
    const res = await fetch(fetchConfig.endpoint as string, {
      method: 'POST',
      ...options,
      ...(variables?.preview ? fetchConfig.previewParams : fetchConfig.params),
      body: JSON.stringify({ query, variables }),
    });

    const json = await res.json();

    if (json.errors) {
      const { message } = json.errors[0];

      throw new Error(message);
    }

    return json.data;
  };
}
