#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 291 "Delete Invd Blnkt Sales Orders"
{
    Caption = 'Delete Invd Blnkt Sales Orders';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Blanket Order"));
            RequestFilterFields = "No.","Sell-to Customer No.","Bill-to Customer No.";
            RequestFilterHeading = 'Blanket Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }

            trigger OnAfterGetRecord()
            var
                ATOLink: Record "Assemble-to-Order Link";
                ApprovalsMgmt: Codeunit "Approvals Mgmt.";
            begin
                Window.Update(1,"No.");

                SalesLine.Reset;
                SalesLine.SetRange("Document Type","Document Type");
                SalesLine.SetRange("Document No.","No.");
                SalesLine.SetFilter("Quantity Invoiced",'<>0');
                if SalesLine.FindFirst then begin
                  SalesLine.SetRange("Quantity Invoiced");
                  SalesLine.SetFilter("Outstanding Quantity",'<>0');
                  if not SalesLine.FindFirst then begin
                    SalesLine.SetRange("Outstanding Quantity");
                    SalesLine.SetFilter("Qty. Shipped Not Invoiced",'<>0');
                    if not SalesLine.FindFirst then begin
                      SalesLine.LockTable;
                      if not SalesLine.FindFirst then begin
                        SalesLine.SetRange("Qty. Shipped Not Invoiced");
                        SalesLine2.SetRange("Blanket Order No.","No.");
                        if not SalesLine2.FindFirst then begin
                          SalesLine.SetFilter("Qty. to Assemble to Order",'<>0');
                          if SalesLine.FindSet then
                            repeat
                              ATOLink.DeleteAsmFromSalesLine(SalesLine);
                            until SalesLine.Next = 0;
                          SalesLine.SetRange("Qty. to Assemble to Order");

                          SalesLine.DeleteAll;

                          SalesCommentLine.SetRange("Document Type","Document Type");
                          SalesCommentLine.SetRange("No.","No.");
                          SalesCommentLine.DeleteAll;

                          ApprovalsMgmt.DeleteApprovalEntry("Sales Header");

                          Delete;

                          Commit;
                        end;
                      end;
                    end;
                  end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Processing sales orders #1##########';
        SalesLine: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        Window: Dialog;
}

