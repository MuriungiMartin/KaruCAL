#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7329 "Whse. Journal Batches List"
{
    Caption = 'Whse. Journal Batches List';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Warehouse Journal Batch";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the warehouse journal batch.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the warehouse journal batch.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the journal batch applies.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the reason code of the warehouse journal batch.';
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign document numbers to the journal lines in this journal batch.';
                }
                field("Registering No. Series";"Registering No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal batch.';
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
            action("Edit Journal")
            {
                ApplicationArea = Basic;
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    WhseJnlLine.TemplateSelectionFromBatch(Rec);
                end;
            }
            group("&Registering")
            {
                Caption = '&Registering';
                Image = PostOrder;
                action("Test Report")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTip = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    var
                        ReportPrint: Codeunit "Test Report-Print";
                    begin
                        ReportPrint.PrintWhseJnlBatch(Rec);
                    end;
                }
                action("&Register")
                {
                    ApplicationArea = Basic;
                    Caption = '&Register';
                    Image = Confirm;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Whse. Jnl.-B.Register";
                    ShortCutKey = 'F9';
                }
                action("Register and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Register and &Print';
                    Image = ConfirmAndPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Whse. Jnl.-B.Register+Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          WhseJnlBatch := Rec;
          while true do begin
            if WMSManagement.LocationIsAllowed("Location Code") then
              exit(true);
            if Next(1) = 0 then begin
              Rec := WhseJnlBatch;
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

        WhseJnlBatch := Rec;
        repeat
          NextSteps := Next(Steps / Abs(Steps));
          if WMSManagement.LocationIsAllowed("Location Code") then begin
            RealSteps := RealSteps + NextSteps;
            WhseJnlBatch := Rec;
          end;
        until (NextSteps = 0) or (RealSteps = Steps);
        Rec := WhseJnlBatch;
        Find;
        exit(RealSteps);
    end;

    var
        WhseJnlLine: Record "Warehouse Journal Line";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        WMSManagement: Codeunit "WMS Management";

    local procedure DataCaption(): Text[250]
    var
        WhseJnlTemplate: Record "Warehouse Journal Template";
    begin
        if not CurrPage.LookupMode then
          if GetFilter("Journal Template Name") <> '' then
            if GetRangeMin("Journal Template Name") = GetRangemax("Journal Template Name") then
              if WhseJnlTemplate.Get(GetRangeMin("Journal Template Name")) then
                exit(WhseJnlTemplate.Name + ' ' + WhseJnlTemplate.Description);
    end;
}

