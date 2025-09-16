#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 172 "Create Recurring Sales Inv."
{
    Caption = 'Create Recurring Sales Inv.';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Standard Customer Sales Code";"Standard Customer Sales Code")
        {
            RequestFilterFields = "Customer No.","Code";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Counter += 1;
                Window.Update(1,10000 * Counter DIV TotalCount);
                CreateSalesInvoice(OrderDate,PostingDate);
            end;

            trigger OnPreDataItem()
            begin
                SetFilter("Valid From Date",'%1|<=%2',0D,OrderDate);
                SetFilter("Valid To date",'%1|>=%2',0D,OrderDate);
                SetRange(Blocked,false);

                TotalCount := Count;
                Window.Open(ProgressMsg);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(OrderDate;OrderDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Order Date';
                }
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close;
        Message(NoOfInvoicesMsg,TotalCount);
    end;

    trigger OnPreReport()
    begin
        if (OrderDate = 0D) or (PostingDate = 0D) then
          Error(MissingDatesErr);
    end;

    var
        Window: Dialog;
        PostingDate: Date;
        OrderDate: Date;
        MissingDatesErr: label 'You must enter both a posting date and an order date.';
        TotalCount: Integer;
        Counter: Integer;
        ProgressMsg: label 'Creating Invoices #1##################';
        NoOfInvoicesMsg: label '%1 invoices were created.';
}

