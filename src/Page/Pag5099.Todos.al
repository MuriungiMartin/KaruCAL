#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5099 "To-dos"
{
    ApplicationArea = Basic;
    Caption = 'To-dos';
    DataCaptionExpression = FORMAT(SELECTSTR(OutputOption + 1,Text001));
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
                    ApplicationArea = Basic;
                    Caption = 'Show as Lines';
                    OptionCaption = 'Salesperson,Team,Campaign,Contact';
                }
                field(OutputOption;OutputOption)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show';
                    OptionCaption = 'No. of To-dos,Contact No.';
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                field(FilterSalesPerson;FilterSalesPerson)
                {
                    ApplicationArea = Basic;
                    Caption = 'Salesperson Filter';
                    TableRelation = "Salesperson/Purchaser";
                }
                field(FilterTeam;FilterTeam)
                {
                    ApplicationArea = Basic;
                    Caption = 'Team Filter';
                    TableRelation = Team;
                }
                field(FilterCampaign;FilterCampaign)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campaign Filter';
                    TableRelation = Campaign;
                }
                field(FilterContact;FilterContact)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact Company No. Filter';
                    TableRelation = Contact where (Type=const(Company));
                }
                field(StatusFilter;StatusFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status Filter';
                    OptionCaption = ' ,Not Started,In Progress,Completed,Waiting,Postponed';
                }
                field(IncludeClosed;IncludeClosed)
                {
                    ApplicationArea = Basic;
                    Caption = 'Include Closed To-dos';
                }
                field(PriorityFilter;PriorityFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Priority Filter';
                    OptionCaption = ' ,Low,Normal,High';
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Basic;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        CreateCaptionSet(Setwanted::Initial);
                    end;
                }
                field(ColumnSet;ColumnSet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column Set';
                    Editable = false;
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
                ApplicationArea = Basic;
                Caption = '&Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Show the to-dos in a matrix.';

                trigger OnAction()
                var
                    MatrixForm: Page "Tasks Matrix";
                begin
                    Clear(MatrixForm);
                    MatrixForm.Load(MatrixColumnCaptions,MatrixRecords,TableOption,ColumnDateFilters,OutputOption,FilterSalesPerson,
                      FilterTeam,FilterCampaign,FilterContact,StatusFilter,IncludeClosed,PriorityFilter);
                    MatrixForm.RunModal;
                end;
            }
            action("Previous Set")
            {
                ApplicationArea = Basic;
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
            action("Next Set")
            {
                ApplicationArea = Basic;
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
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(true);
    end;

    trigger OnOpenPage()
    begin
        CurrSetLength := 32;
        CreateCaptionSet(Setwanted::Initial);
    end;

    var
        MatrixRecords: array [32] of Record Date;
        MatrixMgt: Codeunit "Matrix Management";
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        OutputOption: Option "No. of To-dos","Contact No.";
        TableOption: Option Salesperson,Team,Campaign,Contact;
        StatusFilter: Option " ","Not Started","In Progress",Completed,Waiting,Postponed;
        PriorityFilter: Option " ",Low,Normal,High;
        IncludeClosed: Boolean;
        FilterSalesPerson: Code[250];
        FilterTeam: Code[250];
        FilterCampaign: Code[250];
        FilterContact: Code[250];
        Text001: label 'No. of To-dos,Contact No.';
        ColumnDateFilters: array [32] of Text[50];
        MatrixColumnCaptions: array [32] of Text[1024];
        ColumnSet: Text[1024];
        SetWanted: Option Initial,Previous,Same,Next;
        PKFirstRecInCurrSet: Text[100];
        CurrSetLength: Integer;

    local procedure CreateCaptionSet(SetWanted: Option Initial,Previous,Same,Next)
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,false,PeriodType,'',
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;
}

