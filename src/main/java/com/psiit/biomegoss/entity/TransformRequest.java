package com.psiit.biomegoss.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Map;

/**
 * Request object passed into the conversion endpoint.
 */
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TransformRequest {
	private String inputType;
	private String outputType;
	private Map<String, String> xpath2values;
}
