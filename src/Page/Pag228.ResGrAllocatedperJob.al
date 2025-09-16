#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 228 "Res. Gr. Allocated per Job"
{
    Caption = 'Res. Gr. Allocated per Job';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Resource Gr. Filter";ResourceGrFilter)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Gr. Filter';
                    Lookup = true;
                    TableRelation = "Resource Group";
                    ToolTip = 'Specifies the resource group that the allocations apply to.';
                }
            }
            group("Matrix Options")
            {
                Caption = 'Matrix Options';
                field(PeriodType;PeriodType)
                {
                    ApplicationArea = Jobs;
                    Caption = 'View by';
                    OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                    ToolTip = 'Specifies by which period amounts are displayed.';

                    trigger OnValidate()
                    begin
                        DateControl;
                        SetColumns(Setwanted::Initial);
                        PeriodTypeOnAfterValidate;
                    end;
                }
                field(DateFilter;DateFilter)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Date Filter';
                    ToolTip = 'Specifies the dates that will be used to filter the amounts in the window.';

                    trigger OnValidate()
                    begin
                        DateControl;
                        SetColumns(Setwanted::Initial);
                        DateFilterOnAfterValidate;
                    end;
                }
                field(ColumnsSet;ColumnsSet)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Column set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.';
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
                ApplicationArea = Jobs;
                Caption = 'Show Matrix';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the matrix window to see the specifies values.';

                trigger OnAction()
                var
                    HorizontalRecord: Record "Job Planning Line";
                    ResGrpPerJobFormWithMatrix: Page "ResGrp. Alloc. per Job Matrix";
                begin
                    HorizontalRecord.SetRange("Resource Group No.",ResourceGrFilter);
                    HorizontalRecord.SetRange(Type,HorizontalRecord.Type::Resource);
                    JobRec.SetRange("Resource Gr. Filter",ResourceGrFilter);
                    ResGrpPerJobFormWithMatrix.Load(JobRec,HorizontalRecord,MatrixColumnCaptions,MatrixRecords);
                    ResGrpPerJobFormWithMatrix.RunModal;
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Jobs;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Next);
                end;
            }
            action("Previous Set")
            {
                ApplicationArea = Jobs;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(Setwanted::Previous);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(Setwanted::Initial);
        if HasFilter then
          ResourceGrFilter := GetFilter("Resource Gr. Filter");
    end;

    var
        MatrixRecords: array [32] of Record Date;
        JobRec: Record Job;
        ResRec2: Record Resource;
        ApplicationManagement: Codeunit ApplicationManagement;
        DateFilter: Text;
        ResourceGrFilter: Text;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        CurrSetLength: Integer;
        SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn;
        PKFirstRecInCurrSet: Text[1024];
        MatrixColumnCaptions: array [32] of Text[100];
        ColumnsSet: Text[1024];

    local procedure DateControl()
    begin
        if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
        ResRec2.SetFilter("Date Filter",DateFilter);
        DateFilter := ResRec2.GetFilter("Date Filter");
    end;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,false,PeriodType,DateFilter,PKFirstRecInCurrSet,MatrixColumnCaptions,
          ColumnsSet,CurrSetLength,MatrixRecords);
    end;

    local procedure PeriodTypeOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

