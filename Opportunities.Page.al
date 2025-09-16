#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5131 Opportunities
{
    ApplicationArea = Basic;
    Caption = 'Opportunities';
    DataCaptionExpression = FORMAT(SELECTSTR(OutPutOption + 1,Text002));
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "RM Matrix Management";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TableOption;TableOption)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Show as Lines';
                    OptionCaption = 'Salesperson,Campaign,Contact';
                    ToolTip = 'Specifies which values you want to show as lines in the window.';
                }
                field(OutPutOption;OutPutOption)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Show';
                    OptionCaption = 'No of Opportunities,Estimated Value ($),Calc. Current Value ($),Avg. Estimated Value ($),Avg. Calc. Current Value ($)';
                    ToolTip = 'Specifies if the selected value is shown in the window.';
                }
                field(RoundingFactor;RoundingFactor)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Rounding Factor';
                    OptionCaption = 'None,1,1000,1000000';
                    ToolTip = 'Specifies the factor that is used to round the amounts.';
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(OptionStatusFilter;OptionStatusFilter)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Status Filter';
                    OptionCaption = 'In Progress,Won,Lost';
                    ToolTip = 'Specifies for which status opportunities are displayed.';
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        PeriodTypeOnAfterValidate;
                    end;
                }
                field(MATRIX_CaptionRange;MATRIX_CaptionRange)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowMatrix)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View the data overview according to the selected filters and options.';

                trigger OnAction()
                var
                    MatrixForm: Page "Opportunities Matrix";
                    EstValFilter: Text;
                    CloseOppFilter: Text;
                    SuccesChanceFilter: Text;
                    ProbabilityFilter: Text;
                    CompleteFilter: Text;
                    CaldCurrValFilter: Text;
                    SalesCycleFilter: Text;
                    CycleStageFilter: Text;
                begin
                    Clear(MatrixForm);
                    CloseOppFilter := GetFilter("Close Opportunity Filter");
                    SuccesChanceFilter := GetFilter("Chances of Success % Filter");
                    ProbabilityFilter := GetFilter("Probability % Filter");
                    CompleteFilter := GetFilter("Completed % Filter");
                    EstValFilter := GetFilter("Estimated Value Filter");
                    CaldCurrValFilter := GetFilter("Calcd. Current Value Filter");
                    SalesCycleFilter := GetFilter("Sales Cycle Filter");
                    CycleStageFilter := GetFilter("Sales Cycle Stage Filter");

                    MatrixForm.Load(MATRIX_CaptionSet,MatrixRecords,TableOption,OutPutOption,RoundingFactor,
                      OptionStatusFilter,CloseOppFilter,SuccesChanceFilter,ProbabilityFilter,CompleteFilter,EstValFilter,
                      CaldCurrValFilter,SalesCycleFilter,CycleStageFilter,Periods);

                    MatrixForm.RunModal;
                end;
            }
            action("Next Set")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    CreateCaptionSet(Setwanted::Next);
                end;
            }
            action("Previous Set")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    CreateCaptionSet(Setwanted::Previous);
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(true);
    end;

    trigger OnOpenPage()
    begin
        CreateCaptionSet(Setwanted::Initial);
    end;

    var
        MatrixRecords: array [32] of Record Date;
        MatrixMgt: Codeunit "Matrix Management";
        MATRIX_CaptionSet: array [32] of Text[1024];
        MATRIX_CaptionRange: Text[1024];
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        OptionStatusFilter: Option "In Progress",Won,Lost;
        OutPutOption: Option "No of Opportunities","Estimated Value (LCY)","Calc. Current Value (LCY)","Avg. Estimated Value (LCY)","Avg. Calc. Current Value (LCY)";
        RoundingFactor: Option "None","1","1000","1000000";
        TableOption: Option SalesPerson,Campaign,Contact;
        Text002: label 'No of Opportunities,Estimated Value ($),Calc. Current Value ($),Avg. Estimated Value ($),Avg. Calc. Current Value ($)';
        Periods: Integer;
        Datefilter: Text[1024];
        SetWanted: Option Initial,Previous,Same,Next;
        PKFirstRecInCurrSet: Text[100];

    local procedure CreateCaptionSet(SetWanted: Option Initial,Previous,Same,Next)
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,ArrayLen(MatrixRecords),false,PeriodType,Datefilter,PKFirstRecInCurrSet,
          MATRIX_CaptionSet,MATRIX_CaptionRange,Periods,MatrixRecords);
    end;

    local procedure PeriodTypeOnAfterValidate()
    begin
        CreateCaptionSet(Setwanted::Initial);
    end;
}

