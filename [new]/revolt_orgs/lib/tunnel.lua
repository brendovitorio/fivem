Tunnel = module("revolt", "lib/Tunnel")
Proxy = module("revolt", "lib/Proxy")
Resource = GetCurrentResourceName()

if IsDuplicityVersion() then
    rEVOLT = Proxy.getInterface("rEVOLT")
    rEVOLTclient = Tunnel.getInterface("rEVOLT")

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource, RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
else
    rEVOLT = Proxy.getInterface("rEVOLT")

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource, RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
end