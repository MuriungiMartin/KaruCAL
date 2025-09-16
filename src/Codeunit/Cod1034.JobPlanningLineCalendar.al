#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1034 "Job Planning Line - Calendar"
{
    TableNo = "Job Planning Line";

    trigger OnRun()
    var
        LocalJobPlanningLine: Record "Job Planning Line";
    begin
        LocalJobPlanningLine.SetView(GetView);
        LocalJobPlanningLine.SetFilter("Line Type",'%1|%2',"line type"::Budget,"line type"::"Both Budget and Billable");
        LocalJobPlanningLine.SetRange(Type,Type::Resource);
        LocalJobPlanningLine.SetFilter("No.",'<>''''');
        if LocalJobPlanningLine.FindSet then begin
          repeat
            SetPlanningLine(LocalJobPlanningLine);
            CreateAndSend;
          until LocalJobPlanningLine.Next = 0;
        end;
    end;

    var
        JobPlanningLineCalendar: Record "Job Planning Line - Calendar";
        JobPlanningLine: Record "Job Planning Line";
        Job: Record Job;
        JobTask: Record "Job Task";
        Contact: Record Contact;
        Customer: Record Customer;
        ProjectManagerResource: Record Resource;
        AdditionalResourcesTxt: label 'Additional Resources';
        SetPlanningLineErr: label 'You must specify a job planning line before you can send the appointment.';
        DateTimeFormatTxt: label '<Year4><Month,2><Day,2>T<Hours24,2><Minutes,2><Seconds,2>', Locked=true;
        ProdIDTxt: label '//Microsoft Corporation//Dynamics 365//EN', Locked=true;
        Resource: Record Resource;


    procedure SetPlanningLine(NewJobPlanningLine: Record "Job Planning Line")
    begin
        JobPlanningLine := NewJobPlanningLine;
        UpdateJob;
        UpdateJobTask;
        UpdateResource;
    end;


    procedure CreateAndSend()
    var
        TempEmailItem: Record "Email Item" temporary;
    begin
        if JobPlanningLine."No." = '' then
          Error(SetPlanningLineErr);

        if JobPlanningLineCalendar.ShouldSendCancellation(JobPlanningLine) then
          if CreateCancellation(TempEmailItem) then
            TempEmailItem.Send(true);

        if JobPlanningLineCalendar.ShouldSendRequest(JobPlanningLine) then
          if CreateRequest(TempEmailItem) then
            TempEmailItem.Send(true);
    end;


    procedure CreateRequest(var TempEmailItem: Record "Email Item" temporary): Boolean
    var
        Email: Text[80];
    begin
        if JobPlanningLine."No." = '' then
          Error(SetPlanningLineErr);

        Email := GetResourceEmail(JobPlanningLine."No.");

        if Email <> '' then begin
          JobPlanningLineCalendar.InsertOrUpdate(JobPlanningLine);
          GenerateEmail(TempEmailItem,Email,false);
          exit(true);
        end;
    end;


    procedure CreateCancellation(var TempEmailItem: Record "Email Item" temporary): Boolean
    var
        Email: Text[80];
    begin
        if JobPlanningLine."No." = '' then
          Error(SetPlanningLineErr);

        if not JobPlanningLineCalendar.HasBeenSent(JobPlanningLine) then
          exit(false);

        Email := GetResourceEmail(JobPlanningLineCalendar."Resource No.");
        if Email <> '' then begin
          GenerateEmail(TempEmailItem,Email,true);
          JobPlanningLineCalendar.Delete;
          exit(true);
        end;
    end;

    local procedure GenerateEmail(var TempEmailItem: Record "Email Item" temporary;RecipientEmail: Text[80];Cancel: Boolean)
    var
        TempBlob: Record TempBlob;
        FileMgt: Codeunit "File Management";
        Stream: OutStream;
        ICS: Text;
        FilePath: Text;
    begin
        ICS := GenerateICS(Cancel);
        TempBlob.Blob.CreateOutstream(Stream);
        Stream.Write(ICS);

        FilePath := FileMgt.ServerTempFileName('.ics');
        FileMgt.BLOBExportToServerFile(TempBlob,FilePath);

        TempEmailItem.Init;
        TempEmailItem.Subject := JobTask.Description;
        TempEmailItem."Attachment File Path" := CopyStr(FilePath,1,250);
        TempEmailItem."Attachment Name" := StrSubstNo('%1.ics',JobTask.TableCaption);
        TempEmailItem."Send to" := RecipientEmail;
    end;

    local procedure GenerateICS(Cancel: Boolean) ICS: Text
    var
        StringBuilder: dotnet StringBuilder;
        Location: Text;
        Summary: Text;
        Status: Text;
        Method: Text;
        Description: Text;
    begin
        Location := StrSubstNo('%1, %2, %3',Customer.Address,Customer.City,Customer."Country/Region Code");
        Summary := StrSubstNo('%1:%2:%3',JobPlanningLine."Job No.",JobPlanningLine."Job Task No.",JobPlanningLine."Line No.");

        if Cancel then begin
          Method := 'CANCEL';
          Status := 'CANCELLED';
        end else begin
          Method := 'REQUEST';
          Status := 'CONFIRMED';
        end;
        Description := GetDescription;

        StringBuilder := StringBuilder.StringBuilder;
        with StringBuilder do begin
          AppendLine('BEGIN:VCALENDAR');
          AppendLine('VERSION:2.0');
          AppendLine('PRODID:-' + ProdIDTxt);
          AppendLine('METHOD:' + Method);
          AppendLine('BEGIN:VEVENT');
          AppendLine('UID:' + DelChr(JobPlanningLineCalendar.UID,'<>','{}'));
          AppendLine('ORGANIZER:' + GetOrganizer);
          AppendLine('LOCATION:' + Location);
          AppendLine('DTSTART:' + GetStartDate);
          AppendLine('DTEND:' + GetEndDate);
          AppendLine('SUMMARY:' + Summary);
          AppendLine('DESCRIPTION:' + Description);
          AppendLine('X-ALT-DESC;FMTTYPE=' + GetHtmlDescription(Description));
          AppendLine('SEQUENCE:' + Format(JobPlanningLineCalendar.Sequence));
          AppendLine('STATUS:' + Status);
          AppendLine('END:VEVENT');
          AppendLine('END:VCALENDAR');
        end;

        ICS := StringBuilder.ToString;
    end;

    local procedure GetAdditionalResources() AdditionalResources: Text
    var
        LocalJobPlanningLine: Record "Job Planning Line";
        LocalResource: Record Resource;
    begin
        // Get all resources for the same job task.
        with LocalJobPlanningLine do begin
          SetRange("Job No.",JobPlanningLine."Job No.");
          SetRange("Job Task No.",JobPlanningLine."Job Task No.");
          SetRange(Type,Type::Resource);
          SetFilter("Line Type",'%1|%2',"line type"::Budget,"line type"::"Both Budget and Billable");
          SetFilter("No.",'<>%1&<>''''',Resource."No.");
          if FindSet then begin
            AdditionalResources += '\n\n' + AdditionalResourcesTxt + ':';
            repeat
              LocalResource.Get("No.");
              AdditionalResources += StrSubstNo('\n    (%1) %2 - %3',
                  "Line Type",LocalResource.Name,Description);
            until Next = 0;
          end;
        end;
    end;

    local procedure GetDescription() AppointmentDescription: Text
    var
        AppointmentFormat: Text;
    begin
        AppointmentFormat := Job.TableCaption + ': %1 - %2\r\n';
        AppointmentFormat += JobTask.TableCaption + ': %3 - %4\n\n';
        if Customer.Name <> '' then
          AppointmentFormat += StrSubstNo('%1: %2\n',Customer.TableCaption,Customer.Name);
        AppointmentFormat += Contact.TableCaption + ': %5\n';
        AppointmentFormat += Contact.FieldCaption("Phone No.") + ': %6\n\n';
        AppointmentFormat += Resource.TableCaption + ': (%7) %8 - %9';
        AppointmentDescription := StrSubstNo(AppointmentFormat,
            Job."No.",Job.Description,
            JobTask."Job Task No.",JobTask.Description,
            Contact.Name,Contact."Phone No.",
            JobPlanningLine."Line Type",Resource.Name,JobPlanningLine.Description);

        AppointmentDescription += GetAdditionalResources;
        if ProjectManagerResource.Name <> '' then
          AppointmentDescription += StrSubstNo('\n\n%1: %2',
              Job.FieldCaption("Project Manager"),ProjectManagerResource.Name);
    end;

    local procedure GetHtmlDescription(Description: Text) HtmlAppointDescription: Text
    var
        RegEx: dotnet Regex;
    begin
        HtmlAppointDescription := RegEx.Replace(Description,'\\r','');
        HtmlAppointDescription := RegEx.Replace(HtmlAppointDescription,'\\n','<br>');
        HtmlAppointDescription := 'text/html:<html><body>' + HtmlAppointDescription + '</html></body>';
    end;

    local procedure GetOrganizer(): Text
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        ProjectManagerUser: Record User;
    begin
        ProjectManagerUser.SetRange("User Name",ProjectManagerResource."Time Sheet Owner User ID");
        if ProjectManagerUser.FindFirst then
          if ProjectManagerUser."Authentication Email" <> '' then
            exit(ProjectManagerUser."Authentication Email");

        SMTPMailSetup.Get;
        exit(SMTPMailSetup."User ID");
    end;

    local procedure GetStartDate() StartDateTime: Text
    var
        StartDate: Date;
        StartTime: Time;
    begin
        StartDate := JobPlanningLine."Planning Date";
        if JobPlanningLine.Quantity < 12 then
          Evaluate(StartTime,Format(8));

        StartDateTime := Format(CreateDatetime(StartDate,StartTime),0,DateTimeFormatTxt);
    end;

    local procedure GetEndDate() EndDateTime: Text
    var
        StartDate: Date;
        EndTime: Time;
        Duration: Decimal;
        Days: Integer;
    begin
        Duration := JobPlanningLine.Quantity;
        StartDate := JobPlanningLine."Planning Date";
        if Duration < 12 then
          Evaluate(EndTime,Format(8 + Duration))
        else
          Days := ROUND(Duration / 24,1,'>');

        EndDateTime := Format(CreateDatetime(StartDate + Days,EndTime),0,DateTimeFormatTxt);
    end;

    local procedure GetResourceEmail(ResourceNo: Code[20]): Text[80]
    var
        LocalResource: Record Resource;
        LocalUser: Record User;
    begin
        LocalResource.Get(ResourceNo);
        LocalUser.SetRange("User Name",LocalResource."Time Sheet Owner User ID");
        if LocalUser.FindFirst then
          exit(LocalUser."Authentication Email");
    end;

    local procedure UpdateJob()
    begin
        if Job."No." <> JobPlanningLine."Job No." then begin
          Job.Get(JobPlanningLine."Job No.");
          Customer.Get(Job."Bill-to Customer No.");
          Contact.Get(Customer."Primary Contact No.");
          if Job."Project Manager" <> '' then
            ProjectManagerResource.Get(Job."Project Manager");
        end;
    end;

    local procedure UpdateJobTask()
    begin
        if (JobTask."Job Task No." <> JobPlanningLine."Job Task No.") or (JobTask."Job No." <> JobPlanningLine."Job No.") then
          JobTask.Get(JobPlanningLine."Job No.",JobPlanningLine."Job Task No.");
    end;

    local procedure UpdateResource()
    begin
        if JobPlanningLine."No." <> Resource."No." then
          if JobPlanningLine."No." <> '' then
            Resource.Get(JobPlanningLine."No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Planning Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnDeletePlanningLine(var Rec: Record "Job Planning Line";RunTrigger: Boolean)
    var
        LocalJobPlanningLineCalendar: Record "Job Planning Line - Calendar";
    begin
        if RunTrigger then
          if LocalJobPlanningLineCalendar.HasBeenSent(Rec) then begin
            SetPlanningLine(Rec);
            CreateAndSend;
          end;
    end;
}

