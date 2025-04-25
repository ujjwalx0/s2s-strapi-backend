"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = ({ env }) => ({
    upload: {
        config: {
            provider: 'cloudinary',
            providerOptions: {
                cloud_name: env('CLOUDINARY_NAME'), // No fallback value
                api_key: env('CLOUDINARY_KEY'), // No fallback value
                api_secret: env('CLOUDINARY_SECRET') // No fallback value
            },
            actionOptions: {
                upload: {},
                uploadStream: {},
                delete: {},
            },
        },
    },
});
