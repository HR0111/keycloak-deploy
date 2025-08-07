FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# Build Keycloak optimized for PostgreSQL
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest

COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Environment variables that will be set in Render
ENV KC_DB=postgres
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_HTTP_ENABLED=true
ENV KC_PROXY=edge

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start"]
