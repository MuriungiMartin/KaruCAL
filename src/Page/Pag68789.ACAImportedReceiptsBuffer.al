#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68789 "ACA-Imported Receipts Buffer"
{
    DeleteAllowed = true;
    Editable = true;
    PageType = List;
    SourceTable = UnknownTable61552;
    SourceTableView = where(Posted=const(No));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Transaction Code";"Transaction Code")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Account No.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Receipt No";"Receipt No")
                {
                    ApplicationArea = Basic;
                }
                field(IDNo;IDNo)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Receipting)
            {
                Caption = 'Receipting';
                action("Import Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Import Receipts';
                    Image = ImportExcel;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Arrange your CSV File to have fields in the following order:\'+
                        'Serial\'+
                        'Transaction Code\'+
                        'Cheque No\'+
                        'F Name\'+
                        'M Name\'+
                        'L Name\'+
                        'ID No\'+
                        'Student No.\'+
                        'Amount\'+
                        'Description\'+
                        'Semester\'+
                        '************************************************************\'+
                        'Continue?', true)=false then Error('Cancelled By User: '+UserId);

                        Xmlport.Run(50152,true,true);
                    end;
                }
                action("Post Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Receipts';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Report "Generate Receipts";
                }
            }
        }
    }

    var
        StudPayments: Record UnknownRecord61536;
        RcptBuffer: Integer;
}

