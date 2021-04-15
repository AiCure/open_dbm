
% Function ParseSEMAINEAnnotations is intended to demonstrate example usage
% of SEMAINE Action Unit annotations made with ELAN annotation toolbox.
% This function loads the XML structure from an ELAN annotation file with
% ".eaf" extension, parses it and returns a numerical matrix called
% "activations" of size NUMBER OF FRAMES X NUMBER OF ACTION UNITS. The
% matrix holds binary activation status for each frame / AU combination.
% The matrix also has a row header showing which AU corresponds to which
% row as well as a column header displaying original frame indexes.

% The function takes 1 compulsory and 2 optional arguments: 

% - "filepath" (compulsory) - complete path to an annotation file to parse.
% For example, "/matlab/annotation.eaf" or "C:\matlab\annotation.eaf" on
% Windows.

% - "startFrame" (optional) - ignore all annotations before "startFrame".
% Default is 1.

% - "endFrame" (optional) - ignore all annotations after "endFrame".
% Default is the last frame of a video.

% The function requires XML IO Toolbox
% (http://www.mathworks.com/matlabcentral/fileexchange/12907-xml-io-tools)
% to run properly (supplied).

function activations = ParseSEMAINEAnnotations (filepath, startFrame, endFrame)
    activations = [];

    % Framerate value used to convert ELAN millisecond time slots to more
    % usual frames. 50 is a valid framerate for all SEMAINE videos.
    framerate = 50;

    % A fixed set of 6 Action Units selected for the challenge from the
    % SEMAINE annotations
    aus = [2 12 17 25 28 45];
    
    % Total number of AUs.
	naus = length(aus);
    
    % Load XML structure from the file, return in case of a problem.
    [success, XML] = OpenXML(filepath);
    if ~success
		return
    end
    
    % Parse annotation time slots
    tslots = ParseTimeSlots(XML);
    
    % Init start and end frames with default values
    if nargin < 2
        startFrame = 1;
    end
    
    if nargin < 3
        % Get total number of time slots
        ntslots = length(tslots);
        % Get last slot ID        
        lastID = strcat('ts', num2str(ntslots));
        % Get last time slot value in ms
        lastValue = tslots(lastID);
        % Convert last time slot value in ms to frames
        endFrame = floor((lastValue / 1000) * framerate);
    end
    
    % Get total number of tiers. There are 65 of them, 1 for speech, 32 for
    % activations (1 per AU) and 32 for intensities. We are going to ignore
    % intensity tiers.
    ntiers = length(XML.TIER);
    
    % Compose vector of frame indexes to extract annotations from
	frames = (startFrame:endFrame);
    
    % Preallocate activations matrix
    activations = zeros(length(frames), naus);
    
    indx = 1;
    % Go through all tiers skipping the first one (speech) as well as every
    % intensity tier. A single activation tier is processed at every
    % iteration.
    for k = 2:2:ntiers
		tier = XML.TIER(k);
        % Only extract annotations of selected AUs, skip the rest
        au = strcat('AU', num2str(aus(indx)));
        if strcmp(au, tier.ATTRIBUTE.TIER_ID)
            % Read all activation periods from the current tier
            activationTier = ParseActivationTier(tier, tslots);
            % Convert of all activation periods into frame level numerical
            % representation
            activations(:, indx) = ParseOccurrences(activationTier, frames, framerate);

            indx = indx + 1;
        end
        
        if indx > naus
            break
        end
    end
    
    activations = [frames' activations];
    activations = [[0 aus]; activations];
end

function occurrences = ParseOccurrences (activations, frames, framerate)
    % Preallocate activations vector
    occurrences = zeros(length(frames), 1);
    % Go through all activation periods, convert ms into frames and init
    % corresponding values of activations vector with 1 leaving the rest be 0
	for i = 1:length(activations)
        % Convert ms into frames 
		sframe = floor((activations(i).start / 1000) * framerate);
		eframe = floor((activations(i).end / 1000) * framerate);

        % Determine indexes of frames vector corresponding to the above
        % time frame
		sindx = find(frames == sframe);
		eindx = find(frames == eframe);

        % Mark active set of frames with 1
		occurrences(sindx:eindx) = 1;
	end
end

function activationTier = ParseActivationTier (tier, tslots)
    % Get total number of activation periods
    nactivations = length(tier.ANNOTATION);
    % Preallocate activation tier structure holding start and end time
    % stamps of all activation periods for the given AU
	activationTier = repmat(struct('start', 0, 'end', 0), nactivations, 1);
    % Go through all activation periods and init activation tier
    % structure array
    for i = 1:nactivations
        % Read start time slot ID of the current activation period
		t = tier.ANNOTATION(i).ALIGNABLE_ANNOTATION.ATTRIBUTE.TIME_SLOT_REF1;
        % Read time in ms corresponding to the time slot ID
        activationTier(i).start = tslots(t);
        
        % Read end time slot ID of the current activation period
		t = tier.ANNOTATION(i).ALIGNABLE_ANNOTATION.ATTRIBUTE.TIME_SLOT_REF2;
        % Read time in ms corresponding to the time slot ID
		activationTier(i).end = tslots(t);
    end
end

function tslots = ParseTimeSlots (xmlObject)
    % Get total number of time slots
	nslots = length(xmlObject.TIME_ORDER.TIME_SLOT);
    % Preallocate cell arrays of time slot IDs and values
	tids = cell(nslots, 1);
	tvalues = zeros(nslots, 1);
    % Read all time slot IDs and numerical values (in ms)
	for i = 1:nslots
		tids{i} = xmlObject.TIME_ORDER.TIME_SLOT(i).ATTRIBUTE.TIME_SLOT_ID;
		tvalues(i) = xmlObject.TIME_ORDER.TIME_SLOT(i).ATTRIBUTE.TIME_VALUE;
    end
    % Map time slot IDs and values together so that values are accessible
    % by their IDs
	tslots = containers.Map(tids, tvalues);
end

function [success, xmlObject] = OpenXML (xmlPath)
	fprintf(' *** Attempting to load \"%s\" ... ', xmlPath);
	xmlObject = [];
    success = false;
    % Check if the specified file exists and return error otherwise
	if exist(xmlPath, 'file')
        % Load XML structure
		xmlObject = xml_read(xmlPath);
        % Check if XML object loaded correctly, return error otherwise
		if isempty(xmlObject)
			fprintf(' ERROR - unable to read xml tree *** \n');
			return
		else
			success = true;
		end
	else
		fprintf(' ERROR - specified path does not exist *** \n');
		return
	end
	fprintf(' Done *** \n');
end