#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6304 "Power BI Report Selection"
{
    Caption = 'Power BI Reports Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Power BI Report Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ReportName;ReportName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Report Name';
                    Editable = false;
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        SaveAndClose;
    end;

    var
        DisabledReportSelectedErr: label 'The report that you selected is disabled and cannot be opened on the role center. Enable the selected report or select another report.';
        Context: Text[30];


    procedure SetContext(ParentContext: Text[30])
    begin
        // Sets the ID of the parent page that reports are being selected for.
        Context := ParentContext;
    end;


    procedure SetReportBuffer(var TempPowerBiReportBuffer: Record "Power BI Report Buffer" temporary)
    begin
        // clear the current record and shallow copy the buffer to it
        DeleteAll;
        Copy(TempPowerBiReportBuffer,true);
        Reset;
    end;

    local procedure SaveAndClose()
    var
        PowerBiReportConfiguration: Record "Power BI Report Configuration";
        TempPowerBiReportBuffer: Record "Power BI Report Buffer" temporary;
    begin
        // use a temp buffer record for saving to not disturb the position, filters, etc. of the source table
        // ShareTable = TRUE makes a shallow copy of the record, which is OK since no modifications are made to the records themselves
        TempPowerBiReportBuffer.Copy(Rec,true);

        if not Enabled then begin
          // Let the user disable all reports - only throw an error if the selected report is disabled but others are enabled.
          TempPowerBiReportBuffer.SetRange(Enabled,true);
          if not TempPowerBiReportBuffer.IsEmpty then
            Error(DisabledReportSelectedErr);
          TempPowerBiReportBuffer.Reset;
        end;

        if TempPowerBiReportBuffer.Find('-') then
          repeat
            if PowerBiReportConfiguration.Get(UserSecurityId,TempPowerBiReportBuffer.ReportID,Context) then begin
              if not TempPowerBiReportBuffer.Enabled then
                PowerBiReportConfiguration.Delete;
            end else
              if TempPowerBiReportBuffer.Enabled then begin
                PowerBiReportConfiguration.Init;
                PowerBiReportConfiguration."User Security ID" := UserSecurityId;
                PowerBiReportConfiguration."Report ID" := TempPowerBiReportBuffer.ReportID;
                PowerBiReportConfiguration.Context := Context;
                PowerBiReportConfiguration.Insert;
              end;
          until TempPowerBiReportBuffer.Next = 0;

        CurrPage.Close;
    end;
}

