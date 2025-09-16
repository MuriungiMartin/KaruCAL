#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 571 "No. Series List"
{
    Caption = 'No. Series List';
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    RefreshOnActivate = true;
    SourceTable = "No. Series";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a number series code.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the number series.';
                }
                field(StartDate;StartDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(StartNo;StartNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Starting No.';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the first number in the series.';

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(EndNo;EndNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ending No.';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the last number in the series.';

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(LastDateUsed;LastDateUsed)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Date Used';
                    Editable = false;
                    ToolTip = 'Specifies the date when a number was most recently assigned from the number series.';

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(LastNoUsed;LastNoUsed)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last No. Used';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Specifies the last number that was used from the number series.';

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(WarningNo;WarningNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Warning No.';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field(IncrementByNo;IncrementByNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Increment-by No.';
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        DrillDownActionOnPage;
                    end;
                }
                field("Default Nos.";"Default Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether this number series will be used to assign numbers automatically.';
                }
                field("Manual Nos.";"Manual Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that you can enter numbers manually instead of using this number series.';
                }
                field("Date Order";"Date Order")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies to check that numbers are assigned chronologically.';
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
        area(navigation)
        {
            group("&Series")
            {
                Caption = '&Series';
                Image = SerialNo;
                action(Lines)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Lines';
                    Image = AllLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "No. Series Lines";
                    RunPageLink = "Series Code"=field(Code);
                    ToolTip = 'Define additional information about the number series.';
                }
                action(Relationships)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Relationships';
                    Image = Relationship;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "No. Series Relationships";
                    RunPageLink = Code=field(Code);
                    ToolTip = 'Define the relationship between number series.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateLine(StartDate,StartNo,EndNo,LastNoUsed,WarningNo,IncrementByNo,LastDateUsed);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        StartDate := 0D;
        StartNo := '';
        EndNo := '';
        LastNoUsed := '';
        WarningNo := '';
        IncrementByNo := 0;
        LastDateUsed := 0D;
    end;

    var
        StartDate: Date;
        StartNo: Code[20];
        EndNo: Code[20];
        LastNoUsed: Code[20];
        WarningNo: Code[20];
        IncrementByNo: Integer;
        LastDateUsed: Date;

    local procedure DrillDownActionOnPage()
    begin
        DrillDown;
        CurrPage.Update;
    end;
}

