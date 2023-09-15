### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ b4a38d7c-6de1-4c0c-a9d7-0996d7172016
md"""Setup: test file and path"""

# ╔═╡ 1b1f4e3a-73c8-4d3f-b1e5-c6a1ba2dbe3f
testfilename = "apollo11_202201.npt"

# ╔═╡ 385efbcb-f340-44d3-bb9b-ec4215a41b10
testfilepath = "/mnt/d/data/cddis/npt_crd/apollo11/2022"

# ╔═╡ 9f35b062-b829-4707-ac9c-fc36680b02d4
lines = readlines((testfilepath*"/"*testfilename))


# ╔═╡ 2fc5dbad-52a5-4308-9635-e50bb172d9c9
md"""Header records (CRD pp 4-9) """

# ╔═╡ 5db5c961-d03c-46c4-a60b-5edf99a9a87d
begin #h1
	struct FormatHeader
		Version::Int
	    ProdYear::Int
		ProdMonth::Int
		ProdDay::Int
		ProdHour::Int
	end 
	function FormatHeader(LineIn::String)
	    LineArgs = parse.(Int64,split(LineIn)[3:end])
		FormatHeader(LineArgs...)
	end
end

# ╔═╡ 35191a9e-4b9e-4a9c-9d11-e57d992efe81


# ╔═╡ d922b3ff-0435-46a9-9801-7f4b78da3441
begin #h2
	struct StationHeader
		StationName::String
		CdpPadId::Int
		CdpSysNo::Int
		CdpOccNo::Int
		StationEpochTimeScale::Int
	end
	function StationHeader(LineIn::String)
	    LineArgs = parse.(Int64,split(LineIn)[2:end])
		StationHeader(LineArgs...)
	end
end

# ╔═╡ 2e293329-81c9-4836-a8e6-3b0c41bce461
begin #h3
	struct TargetHeader
		TargetName::String
		ILRSSatId::Int
		SIC::Int
		NORADId::Int
		SpacecraftEpochTimeScale::Int
		TargetType::Int
	end
	function TargetHeader(LineIn::String)
	    LineArgs = parse.(Int64,split(LineIn)[2:end])
		TargetHeader(LineArgs...)
	end
end

# ╔═╡ 5ee71b6c-1203-4600-bed9-58c8d7832e3e
begin #h4
	struct SessionHeader
	    DataType::Int
		StartYear::Int
		StartMonth::Int
		StartDay::Int
		StartHour::Int
		StartMinute::Int
		StartSecond::Int
		 
		EndYear::Int
		EndMonth::Int
		EndDay::Int
		EndHour::Int
		EndMinute::Int
		EndSecond::Int

		ReleaseFlag::Int
		TropoCorr::Int
		COMCorr::Int
		RecvAmplCorr::Int
		StationSysDelayCorr::Int
		SpacecraftSysDelayCorr::Int
		RangeType::Int

		DataQualityAlert::Int
	end
	function SessionHeader(LineIn::String)
		LineArgs = parse.(Int,split(LineIn)[2:end])
		SessionHeader(LineArgs...)
	end
end

# ╔═╡ 8a12016a-23dc-4a95-ad5c-b7b373a3908f
md""" Configuration Records (CRD pp 9-14)

# ╔═╡ d280bd98-18ca-42fd-b477-724a7fc926d7
begin #c0
	struct SystemConfig
		DetailType::Int
		Transmitλ::Float32
		CfgIds::Vector{String}
		#CptCfgIds::Vector{String}
	end
	function SystemConfig(LineIn::String)
		Args = split(LineIn)[2:end]
		SystemConfig(
			parse(Int,Args[1]),
			parse(Float32,Args[2]),
			Args[3:end]
		)
	end
end

# ╔═╡ 6ba03c58-4817-4cd3-ad1c-f6dd017ad4e7
begin #c1
	struct LaserConfig
		DetailType::Int
		LaserConfigID::String
		LaserType::String
		Primaryλ_nm::Float32
		NominalFireRate_Hz::Float32
		PulseE_mJ::Float32
		PulseFWHM_ps::Float32
		BeamDiv_arcsec::Float32
		NPulsePerSemitrain::Int
	end
	function LaserConfig(LineIn::String)
		Args = split(LineIn)[2:end]
		Floats = parse.(Float32,Args[4:8])
		
		LaserConfig(parse(Int,Args[1]),
			Args[2],
			Args[3],
			Floats...,
			parse(Int,Args[end])
		)
		
	end
end


# ╔═╡ 5c8fb36c-bde2-4ed4-9112-6e89a5db3385
begin #c2
	struct DetectorConfig
		DetailType::Int
		DetectorConfigID::String
		DetectorType::String
		Applicableλ_nm::Float32
		QuantumEff_pct::Float32
		AppliedVoltage_V::Float32
		DarkCount_kHz::Float32
		OutputPulseType::String
		OutputPulseWidth_ps::Float32
		SpectralFilter_nm::Float32
		SpectralFilterTransmission_pct::Float32
		SpatialFilter_arcs::Float32
		ExternalSignalProcessing::String
	end
	function DetectorConfig(LineIn::String)
		Args = split(LineIn)[2:end]
		Floats1 = parse.(Float32,Args[4:7])
		Floats2 = parse.(Float32,Args[9:12])
		DetectorConfig(parse(Int,Args[1]),
			Args[2],
			Args[3],
			Floats1...,
			Args[8],
			Floats2...,
			Args[13])
	end
end

# ╔═╡ ba8e6189-b1aa-4834-b0ef-a36c3ab677d7
begin #c3
	struct TimingConfig
		DetailType::Int
		TimingCfgID::String
		TimeSrc::String
		FreqSrc::String
		Timer::String
		TimerSerialNo::String
		EpochDelay_μs::Float32
	end
	function TimingConfig(LineIn::String)
		Args = split(LineIn)[2:end]
		TimingConfig(parse(Int,Args[1]),
			Args[2:end-1]...,
			parse(Float32,Args[end]))
	end
end

# ╔═╡ c309f2a2-4bd7-4383-a0e2-1054fa5f5f6e
begin #c4
	struct TransponderConfig
		DetailType::Int
		TransponderCfgID::String
		EstStationUTCOffset_ns::Float32
		EstStationOscDrift_pp1e15::Float32
		EstTransponderUTCOffset::Float32
		EstTransponderOscDrift_pp1e15::Float32
		TransponderClockReferenceTime_s::Float32
		StationClockOffsetDriftIndicator::Int
		SpacecraftClockOffsetDriftIndicator::Int
		SpacecraftTimeSimplified::Int
	end
	function TransponderConfig(LineIn::String)
		Args = split(LineIn)[2:end]
		print(Args)
		TransponderConfig(parse(Int,Args[1]),
			Args[2],
		    parse.(Float32,Args[3:7]),
			parse.(Int,Args[8:end]),
		)

	end
end

# ╔═╡ 796724d6-a096-4711-bd84-4cf4444b8482
md""" Data Records (CRD pp. 15-24, partially implemented) """

# ╔═╡ d984865b-a605-4f9a-a7e7-0680e761bb06
begin #10
	struct FullRateRangeRecord
		SecondsOfDay::Float64
		TimeOfFlight_s::Float64
		SysCfgID::String
		EpochEvent::Int
		FilterFlag::Int
		DetectorChannel::Int
		StopNumber::Int
		RecvAmplitude::Int
	end
	function FullRateRangeRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		FullRateRangeRecord(
			parse.(Float64,Args[1:2])...,
			Args[3],
			parse.(Int,Args[4:8])...
		)
	end
end

# ╔═╡ 5a863035-3a36-4c89-8f13-a6adf8589915
begin #11
	struct NormalPointRangeRecord
		SecondsOfDay::Float64
		TimeOfFlight_s::Float64
		SysCfgID::String
		EpochEvent::Int
		NormalPointWindowLength_s::Float64
		NRawRanges::Int
		BinRMS_ps::Float64
		BinSkew::Float64
		BinKurt::Float64
		BinPeak_ps::Float64
		ReturnRate_pct::Float64
		DetectorChannel::Int
	end
	function NormalPointRangeRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		#print(Args)
		NormalPointRangeRecord(parse.(Float64,Args[1:2])...,
			Args[3],
			parse(Int,Args[4]),
			parse(Float64,Args[5]),
			parse(Int,Args[6]),
			parse.(Float64,Args[7:11])...,
			parse(Int,Args[12])
		)
	end
end

# ╔═╡ a432816e-49f3-4c8d-a8df-2c613f7ea83e
begin #12
	struct RangeSupplementRecord
		SecondsOfDay::Float64
		SysCfgID::String
		TroposphericRefractionCorrectionOneWay_ps::Float64
		TargetCenterOfMassCorrectionOneWay_m::Float64
		NeutralDensityFilterValue::Float64
		TimeBiasApplied_s::Float64
	end
	function RangeSupplementRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		RangeSupplementRecord(parse(Float64,Args[1]),
			Args[2],
			parse.(Float64,Args[3:6])...)
	end
end

# ╔═╡ 2761fb21-8eaf-4108-968b-faad55d6068b
begin #20
	struct MeteorologicalRecord
		SecondsOfDay::Float64
		SurfacePressure_mbar::Float64
		SurfaceTemperature_K::Float64
		SurfaceRelativeHumidity_pct::Float64
		OriginOfValues::Int
	end
	function MeteorologicalRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		MeteorologicalRecord(parse.(Float64,Args[1:4])...,
			parse(Int,Args[5]))
	end
end

# ╔═╡ e9b7f296-3d79-4f5a-9cb1-a266958ea765
begin #21
	struct MeteorologicalSupplementRecord
		SecondsOfDay::Float64
		WindSpeed_mpers::Float64
		WindDirection_azdegfromnorth::Float64
		PrecipType::String
		Visibility_km::Int
		SkyClarity::Float64
		AtmosphericSeeing_arcsec::Int
		CloudCover_pct::Int
	end
	function MeteorologicalSupplementRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		MeteorologicalSupplementRecord(parse.(Float64,Args[1:3])...,
		    Args[4],
			parse(Int,Args[5]),
		    parse(Float64,Args[6]),
			parse.(Int,Args[7:8])...)
	end
end

# ╔═╡ 5e6c2908-77ab-4d00-ba0b-fe8b85a49aee
begin #30
	struct PointingAnglesRecord
		SecondsOfDay::Float64
		Azimuth_deg::Float64
		Elevation_deg::Float64
		DirectionFlag::Int
		AngleOriginIndicator::Int
		RefractionCorrected::Int
	end
	function PointingAnglesRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		PointingAnglesRecord(parse.(Float64,args[1:3])...,
			parse.(Int,args[4:6])...)
	end
end

# ╔═╡ af777a72-156c-4e9f-9e74-3cd13d52e6c5
begin #40
	struct CalibrationRecord
		SecondsOfDay::Float64
		TypeOfData::Int
		SysCfgID::String
		NDataPtsRecorded::Int
		NDataPtsUsed::Int
		OneWayTargetDistance_m::Float64
		CalSystemDelay_ps::Float64
		CalDelayShift_ps::Float64
		RMSRawSysDelay_ps::Float64
		SkewRawSystemDelay::Float64
		KurtRawSystemDelay::Float64
		PeakMinusMean_ps::Float64
		CalTypeIndicator::Int
		DetectorChannel::Int
	end
	function CalibrationRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		CalibrationRecord(parse(Float64,Args[1]),
		parse(Int,Args[2]),
		Args[3],
		parse.(Int,Args[4:5])...,
		parse.(Float64,Args[6:12])...,
		parse.(Int,Args[13:14])...)
	end
end

# ╔═╡ 6cfc0a52-8673-4411-a437-228fef2f5031
begin #50
	struct SessionStatisticsRecord
		SysCfgID::String
		SessionRMS_ps::Float64
		SessionSkew::Float64
		SessionKurt::Float64
		SessionPeakMinusMean_ps::Float64
		DataQualityIndicator::Int
	end
	function SessionStatisticsRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		SessionStatisticsRecord(Args[1],
		    parse.(Float64,Args[2:5])...,
			parse(Int,Args[6]))
	end
end

# ╔═╡ 218c4c88-049b-4866-833e-0cf0dc79f73a
SessionStatisticsRecord(lines[12])
#CalibrationRecord(lines[11])
#MeteorologicalRecord(lines[10])
#print(split(lines[9])[2:end])
#NormalPointRangeRecord(lines[9])
#TimingConfig(lines[8])
#DetectorConfig(lines[7])
#LaserConfig(lines[6])
#SystemConfig(lines[5])

# ╔═╡ e66ea9bc-40b0-4cac-80f1-1cef500f96f7
begin #60
	struct CompatibilityRecord
		SysCfgID::String
		SystemChangeIndicator::Int
		SystemConfigIndicator::Int
	end
	function CompatibilityRecord(LineIn::String)
		Args = split(LineIn)[2:end]
		CompatibilityRecord(Args[1],
		    parse.(Int,Args[2:3])...)
	end
end

# ╔═╡ 29809113-2d64-4b21-bd2f-e1e705058f76
begin #9X or 00
	struct UserDefinedOrComment
		Record::String
	end
	function UserDefinedOrComment(LineIn::String)
		UserDefinedOrComment[3:end]
	end
end

# ╔═╡ aa9a6cf1-e723-4eaf-90d2-2a36f652537c
struct FullRateRecordStructure 
	Format::FormatHeader
	Station::StationHeader
	Target::TargetHeader
	Session::SessionHeader
	SysCfg::SystemConfig
	LaserCfg::Union{LaserConfig,Nothing}
	DetectorCfg::Union{DetectorConfig,Nothing}
	TimingCfg::Union{TimingConfig,Nothing}
	TransponderConfig::Union{TransponderConfig,Nothing}
	Data::FullRateRangeRecord
	RangeSupplement::Union{RangeSupplementRecord,Nothing}
	Meteorological::MeteorologicalRecord
	MeteorologicalSupplement::Union{MeteorologicalSupplementRecord,Nothing}
	PointingAngles::PointingAnglesRecord
	CalibrationStatistics::Union{CalibrationRecord,Nothing}
	SessionStatistics::Union{SessionStatisticsRecord,Nothing}
	Compatibility::Union{CompatibilityRecord,Nothing}
	UserDefined::Union{Vector{UserDefinedOrComment},Nothing}
	Comments::Union{Vector{UserDefinedOrComment},Nothing}
end

# ╔═╡ b8fbaa38-ba3d-4de9-b096-1d8dc0ccb4c5
struct SampledEngineeringStructure 
Format::FormatHeader
	Station::StationHeader
	Target::TargetHeader
	Session::SessionHeader
	SysCfg::SystemConfig
	LaserCfg::Union{LaserConfig,Nothing}
	DetectorCfg::Union{DetectorConfig,Nothing}
	TimingCfg::Union{TimingConfig,Nothing}
	TransponderConfig::Union{TransponderConfig,Nothing}
	Data::FullRateRangeRecord
	RangeSupplement::Union{RangeSupplementRecord,Nothing}
	Meteorological::MeteorologicalRecord
	MeteorologicalSupplement::Union{MeteorologicalSupplementRecord,Nothing}
	PointingAngles::PointingAnglesRecord
	CalibrationStatistics::Union{CalibrationRecord,Nothing}
	SessionStatistics::Union{SessionStatisticsRecord,Nothing}
	Compatibility::Union{CompatibilityRecord,Nothing}
	UserDefined::Union{Vector{UserDefinedOrComment},Nothing}
	Comments::Union{Vector{UserDefinedOrComment},Nothing}
end

# ╔═╡ 6492fa0b-bb0b-4626-b3fb-ec17a7e92224
struct NormalPointStructure
	Format::FormatHeader
	Station::StationHeader
	Target::TargetHeader
	Session::SessionHeader
	SysCfg::SystemConfig
	LaserCfg::Union{LaserConfig,Nothing}
	DetectorCfg::Union{DetectorConfig,Nothing}
	TimingCfg::Union{TimingConfig,Nothing}
	TransponderConfig::Union{TransponderConfig,Nothing}
	Data::NormalPointRangeRecord
	RangeSupplement::Union{RangeSupplementRecord,Nothing}
	Meteorological::MeteorologicalRecord
	MeteorologicalSupplement::Union{MeteorologicalSupplementRecord,Nothing}
	PointingAngles::Union{PointingAnglesRecord,Nothing}
	CalibrationStatistics::Union{CalibrationRecord,Nothing}
	SessionStatistics::Union{SessionStatisticsRecord,Nothing}
	Compatibility::Union{CompatibilityRecord,Nothing}
	UserDefined::Union{Vector{UserDefinedOrComment},Nothing}
	Comments::Union{Vector{UserDefinedOrComment},Nothing}
end

# ╔═╡ Cell order:
# ╠═b4a38d7c-6de1-4c0c-a9d7-0996d7172016
# ╠═1b1f4e3a-73c8-4d3f-b1e5-c6a1ba2dbe3f
# ╠═385efbcb-f340-44d3-bb9b-ec4215a41b10
# ╠═9f35b062-b829-4707-ac9c-fc36680b02d4
# ╠═2fc5dbad-52a5-4308-9635-e50bb172d9c9
# ╠═218c4c88-049b-4866-833e-0cf0dc79f73a
# ╠═5db5c961-d03c-46c4-a60b-5edf99a9a87d
# ╠═35191a9e-4b9e-4a9c-9d11-e57d992efe81
# ╠═d922b3ff-0435-46a9-9801-7f4b78da3441
# ╠═2e293329-81c9-4836-a8e6-3b0c41bce461
# ╠═5ee71b6c-1203-4600-bed9-58c8d7832e3e
# ╠═8a12016a-23dc-4a95-ad5c-b7b373a3908f
# ╠═d280bd98-18ca-42fd-b477-724a7fc926d7
# ╠═6ba03c58-4817-4cd3-ad1c-f6dd017ad4e7
# ╠═5c8fb36c-bde2-4ed4-9112-6e89a5db3385
# ╠═ba8e6189-b1aa-4834-b0ef-a36c3ab677d7
# ╠═c309f2a2-4bd7-4383-a0e2-1054fa5f5f6e
# ╠═796724d6-a096-4711-bd84-4cf4444b8482
# ╠═d984865b-a605-4f9a-a7e7-0680e761bb06
# ╠═5a863035-3a36-4c89-8f13-a6adf8589915
# ╠═a432816e-49f3-4c8d-a8df-2c613f7ea83e
# ╠═2761fb21-8eaf-4108-968b-faad55d6068b
# ╠═e9b7f296-3d79-4f5a-9cb1-a266958ea765
# ╠═5e6c2908-77ab-4d00-ba0b-fe8b85a49aee
# ╠═af777a72-156c-4e9f-9e74-3cd13d52e6c5
# ╠═6cfc0a52-8673-4411-a437-228fef2f5031
# ╠═e66ea9bc-40b0-4cac-80f1-1cef500f96f7
# ╠═29809113-2d64-4b21-bd2f-e1e705058f76
# ╠═aa9a6cf1-e723-4eaf-90d2-2a36f652537c
# ╠═b8fbaa38-ba3d-4de9-b096-1d8dc0ccb4c5
# ╠═6492fa0b-bb0b-4626-b3fb-ec17a7e92224
