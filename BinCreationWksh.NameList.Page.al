#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7373 "Bin Creation Wksh. Name List"
{
    Caption = 'Bin Creation Wksh. Name List';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Bin Creation Wksh. Name";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a name for the worksheet.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the worksheet.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code for which the worksheet should be used.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Edit Worksheet")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Worksheet';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    BinCreateLine.TemplateSelectionFromBatch(Rec);
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          BinCreateName := Rec;
          while true do begin
            if WMSManagement.LocationIsAllowed("Location Code") then
              exit(true);
            if Next(1) = 0 then begin
              Rec := BinCreateName;
              if Find(Which) then
                while true do begin
                  if WMSManagement.LocationIsAllowed("Location Code") then
                    exit(true);
                  if Next(-1) = 0 then
                    exit(false);
                end;
            end;
          end;
        end;
        exit(false);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        RealSteps: Integer;
        NextSteps: Integer;
    begin
        if Steps = 0 then
          exit;

        BinCreateName := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          if WMSManagement.LocationIsAllowed("Location Code") then begin
            RealSteps := RealSteps + NextSteps;
            BinCreateName := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := BinCreateName;
        Find;
        exit(RealSteps);
    end;

    trigger OnOpenPage()
    begin
        BinCreateLine.OpenWkshBatch(Rec);
    end;

    var
        BinCreateLine: Record "Bin Creation Worksheet Line";
        BinCreateName: Record "Bin Creation Wksh. Name";
        WMSManagement: Codeunit "WMS Management";

    local procedure DataCaption(): Text[250]
    var
        BinCreateTemplate: Record "Bin Creation Wksh. Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Worksheet Template Name") <> '' then
            if GetRangeMin("Worksheet Template Name") = GetRangemax("Worksheet Template Name") then
              if BinCreateTemplate.Get(GetRangeMin("Worksheet Template Name")) then
                exit(BinCreateTemplate.Name + ' ' + BinCreateTemplate.Description);
    end;
}

