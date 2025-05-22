//package com.jenna.snapster.core.system;
//
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//@Controller
//public class RedirectController {
//
//    @GetMapping("/oauth2/redirect")
//    public String redirectToApp(@RequestParam String accessToken, Model model) {
//        model.addAttribute("accessToken", accessToken);
//        return "redirect";
//    }
//}
