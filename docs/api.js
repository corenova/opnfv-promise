YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "ComputeCapacity",
        "ComputeService",
        "Hypervisor",
        "ProviderService",
        "ResourceElement",
        "ResourcePool",
        "ResourceProvider",
        "ResourceReservation",
        "ServiceCapacity",
        "StormForge",
        "StormForgeAsset",
        "StormForgeResource"
    ],
    "modules": [
        "ResourceProvider",
        "ResourceReservation",
        "StormForge",
        "StormForgeAsset",
        "StormForgeResource"
    ],
    "allModules": [
        {
            "displayName": "ResourceProvider",
            "name": "ResourceProvider",
            "description": "Capacity of the compute in cores, ram and instances"
        },
        {
            "displayName": "ResourceReservation",
            "name": "ResourceReservation",
            "description": "Resource reservation data model"
        },
        {
            "displayName": "StormForge",
            "name": "StormForge",
            "description": "Provides the VIM Extensibe services"
        },
        {
            "displayName": "StormForgeAsset",
            "name": "StormForgeAsset",
            "description": "StormForge Asset describes the actual instance properties such as the status, IP Address to reach etc.,"
        },
        {
            "displayName": "StormForgeResource",
            "name": "StormForgeResource",
            "description": "A pool of resources from various Resource Providers"
        }
    ]
} };
});