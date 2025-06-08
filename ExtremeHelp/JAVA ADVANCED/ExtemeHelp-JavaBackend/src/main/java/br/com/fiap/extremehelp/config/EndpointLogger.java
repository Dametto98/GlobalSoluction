package br.com.fiap.extremehelp.config;

import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

@Component
public class EndpointLogger implements ApplicationListener<ContextRefreshedEvent> {

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        System.out.println("========================================================================");
        System.out.println("====== ENDPOINTS REGISTRADOS NA APLICAÇÃO ======");
        System.out.println("========================================================================");
        
        event.getApplicationContext()
            .getBean(RequestMappingHandlerMapping.class)
            .getHandlerMethods()
            .forEach((key, value) -> System.out.println(key + "  ==>  " + value));
            
        System.out.println("========================================================================");
    }
}
