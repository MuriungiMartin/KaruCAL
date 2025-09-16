#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6010 "Res.Gr. Availability (Service)"
{
    Caption = 'Res.Gr. Availability (Service)';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SaveValues = true;
    SourceTable = "Resource Group";

    layout
    {
        area(content)
        {
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
                        DateControl;
                        SetColumns(Setwanted::Initial);
                    end;
                }
                field(DateFilter;DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Date Filter';

                    trigger OnValidate()
                    begin
                        DateControl;
                        SetColumns(Setwanted::Initial);
                        DateFilterOnAfterValidate;
                    end;
                }
                field(ColumnsSet;ColumnsSet)
                {
                    ApplicationArea = Basic;
                    Caption = 'Column set';
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

                trigger OnAction()
                var
                    MatrixForm: Page "Res. Gr. Avail. (Serv.) Matrix";
                begin
                    MatrixForm.SetData(
                      CurrentDocumentType,CurrentDocumentNo,CurrentEntryNo,
                      MatrixColumnCaptions,MatrixRecords,PeriodType);
                    MatrixForm.SetTableview(Rec);
                    MatrixForm.RunModal;
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
                    SetColumns(Setwanted::Next);
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
                    SetColumns(Setwanted::Previous);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ServMgtSetup.Get;
        SetColumns(Setwanted::Initial);
    end;

    var
        MatrixRecords: array [32] of Record Date;
        ResRec2: Record Resource;
        ServMgtSetup: Record "Service Mgt. Setup";
        ApplicationManagement: Codeunit ApplicationManagement;
        CurrentDocumentType: Integer;
        CurrentDocumentNo: Code[20];
        CurrentEntryNo: Integer;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        DateFilter: Text;
        SetWanted: Option Initial,Previous,Same,Next;
        PKFirstRecInCurrSet: Text[1024];
        MatrixColumnCaptions: array [32] of Text[100];
        ColumnsSet: Text[1024];
        CurrSetLength: Integer;


    procedure SetData(DocumentType: Integer;DocumentNo: Code[20];EntryNo: Integer)
    begin
        CurrentDocumentType := DocumentType;
        CurrentDocumentNo := DocumentNo;
        CurrentEntryNo := EntryNo;
    end;

    local procedure DateControl()
    begin
        if ApplicationManagement.MakeDateFilter(DateFilter) = 0 then;
        ResRec2.SetFilter("Date Filter",DateFilter);
        DateFilter := ResRec2.GetFilter("Date Filter");
    end;


    procedure SetColumns(SetWanted: Option Initial,Previous,Same,Next)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,false,PeriodType,DateFilter,
          PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnsSet,CurrSetLength,MatrixRecords);
    end;

    local procedure DateFilterOnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

