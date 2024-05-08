package com.cybage.winepark.controller;

import com.cybage.winepark.service.WineService;
import com.cybage.winepark.domain.Wine;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.cybage.winepark.service.WineServiceImpl;
import com.cybage.winepark.dto.WineDto;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;

@RestController
@RequestMapping("wine")
@Slf4j
@AllArgsConstructor
public class WineController {
    WineService wineService;
    WineServiceImpl wineServiceImpl;
    static final String HEADERS = "Host Info";

    @GetMapping("getAllWines")
    public ResponseEntity<List<Wine>> getAllWines() {
        log.info("CONTROLLER: getAllWines");
        List<Wine> wines = wineService.getAllWines();

        String zone = getMetadata("instance/zone");
        String vpcId = getMetadata("instance/network-interfaces/0/network");
        String subnetId = getMetadata("instance/network-interfaces/0/subnet");
        String hostName = getMetadata("instance/name");
        String hostIp = getMetadata("instance/network-interfaces/0/ip");
        HttpHeaders headers = new HttpHeaders();
        headers.add("X-Instance-Zone", zone);
        headers.add("X-VPC-ID", vpcId);
        headers.add("X-Subnet-ID", subnetId);
        headers.add("X-HOST-NAME", hostName);
        headers.add("X-HOST-IP", hostIp);


        return new ResponseEntity<>(wines,headers, HttpStatus.OK);
    }

    @GetMapping("getWineById/{id}")
    public  ResponseEntity<Wine> getWineById(@PathVariable("id") Integer id) {
        log.info("CONTROLLER: getWineById");
        Wine wine = wineService.getWineById(id);
        String osInfo= wineServiceImpl.getOperatingSystemInfo();
        HttpHeaders headers = new HttpHeaders();
        headers.add(HEADERS, osInfo);
        return new ResponseEntity<>(wine,headers, HttpStatus.OK);
    }
}
