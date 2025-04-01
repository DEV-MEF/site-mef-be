import type { Schema, Struct } from '@strapi/strapi';

export interface StreamingVideos extends Struct.ComponentSchema {
  collectionName: 'components_streaming_videos';
  info: {
    displayName: 'Videos';
  };
  attributes: {
    cover: Schema.Attribute.Media<'images' | 'files' | 'videos' | 'audios'>;
    description: Schema.Attribute.String;
    link: Schema.Attribute.String;
    plataforn: Schema.Attribute.Enumeration<['Youtube']>;
  };
}

export interface TagsNews extends Struct.ComponentSchema {
  collectionName: 'components_tags_news';
  info: {
    displayName: 'News';
  };
  attributes: {
    name: Schema.Attribute.String;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'streaming.videos': StreamingVideos;
      'tags.news': TagsNews;
    }
  }
}
