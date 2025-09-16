#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 454 "Job Queue - Send Notification"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink."Link ID" := 0;
        RecordLink."Record ID" := RecordId;
        if Status = Status::Error then
          RecordLink.Description := CopyStr(GetErrorMessage,1,MaxStrLen(RecordLink.Description))
        else
          RecordLink.Description := Description;
        SetURL(Rec,RecordLink);
        RecordLink.Type := RecordLink.Type::Note;
        RecordLink.Created := CurrentDatetime;
        RecordLink."User ID" := UserId;
        RecordLink.Company := COMPANYNAME;
        RecordLink.Notify := true;
        RecordLink."To User ID" := "User ID";
        SetText(Rec,RecordLink);
        RecordLink.Insert;
    end;

    var
        ErrorText1: label 'Error when processing ''%1''.';
        ErrorText2: label 'Error message:';
        Text001: label '''%1'' finished successfully.', Comment='%1 = job description, e.g. ''Post Sales Order 1234''';

    local procedure SetURL(var JobQueueEntry: Record "Job Queue Entry";var RecordLink: Record "Record Link")
    var
        Link: Text;
    begin
        with JobQueueEntry do begin
          // Generates a URL such as dynamicsnav://host:port/instance/company/runpage?page=672&$filter=
          // The intent is to open up the Job Queue Entries page and show the list of "my errors".
          // TODO: Leverage parameters ",JobQueueEntry,TRUE)" to take into account the filters, which will add the
          // following to the Url: &$filter=JobQueueEntry.Status IS 2 AND JobQueueEntry."User ID" IS <UserID>.
          // This will also require setting the filters on the record, such as:
          // SETFILTER(Status,'=2');
          // SETFILTER("User ID",'=%1',"User ID");
          Link := GetUrl(DefaultClientType,COMPANYNAME,Objecttype::Page,Page::"Job Queue Entries") +
            StrSubstNo('&$filter=''%1''.''%2''%20IS%20''2''%20AND%20''%1''.''%3''%20IS%20''%4''&mode=View',
              HtmlEncode(TableName),HtmlEncode(FieldName(Status)),HtmlEncode(FieldName("User ID")),HtmlEncode("User ID"));

          RecordLink.URL1 := CopyStr(Link,1,MaxStrLen(RecordLink.URL1));
          if StrLen(Link) > MaxStrLen(RecordLink.URL1) then
            RecordLink.URL2 := CopyStr(Link,MaxStrLen(RecordLink.URL1) + 1,MaxStrLen(RecordLink.URL2));
        end;
    end;

    local procedure SetText(var JobQueueEntry: Record "Job Queue Entry";var RecordLink: Record "Record Link")
    var
        TypeHelper: Codeunit "Type Helper";
        s: Text;
        lf: Text;
        c1: Byte;
    begin
        with JobQueueEntry do begin
          c1 := 13;
          lf[1] := c1;

          if Status = Status::Error then
            s := StrSubstNo(ErrorText1,Description) + lf + ErrorText2 + ' ' + GetErrorMessage
          else
            s := StrSubstNo(Text001,Description);

          TypeHelper.WriteRecordLinkNote(RecordLink,s);
        end;
    end;

    local procedure HtmlEncode(InText: Text[1024]): Text[1024]
    var
        SystemWebHttpUtility: dotnet HttpUtility;
    begin
        SystemWebHttpUtility := SystemWebHttpUtility.HttpUtility;
        exit(SystemWebHttpUtility.HtmlEncode(InText));
    end;
}

