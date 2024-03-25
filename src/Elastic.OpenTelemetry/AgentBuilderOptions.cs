// Licensed to Elasticsearch B.V under one or more agreements.
// Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
// See the LICENSE file in the project root for more information

using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using OpenTelemetry.Trace;

namespace Elastic.OpenTelemetry;

/// <summary>
/// Expert options to provide to <see cref="AgentBuilder"/> to control its initial OpenTelemetry registration
/// </summary>
public record AgentBuilderOptions
{
	/// <summary>
	/// Provide an additional logger to the internal file logger.
	/// <para>
	/// The agent will always log to file if a Path is provided using the <c>ELASTIC_OTEL_LOG_DIRECTORY</c>
	/// environment variable.</para>
	/// </summary>
	public ILogger? Logger { get; init; }

	/// <summary>
	/// Provides an <see cref="IServiceCollection"/> to register the agent into.
	/// If null a new local instance will be used.
	/// </summary>
	public IServiceCollection? Services { get; init; }

	/// <summary>
	/// The initial activity sources to listen to.
	/// <para>>These can always later be amended with <see cref="TracerProviderBuilder.AddSource"/></para>
	/// </summary>
	public string[] ActivitySources { get; init; } = [];

	/// <summary>
	/// Stops <see cref="AgentBuilder"/> to register OLTP exporters, useful for testing scenarios
	/// </summary>
	public bool SkipOtlpExporter { get; init; }

	/// <summary>
	/// Optional name which is used when retrieving OTLP options.
	/// </summary>
	public string? OtlpExporterName { get; init; }
}