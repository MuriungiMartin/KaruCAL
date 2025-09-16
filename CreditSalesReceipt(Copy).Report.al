#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65011 "Credit Sales Receipt (Copy)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Credit Sales Receipt (Copy).rdlc';

    dataset
    {
        dataitem("Sales Shipment Header";"Sales Shipment Header")
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000024; 1000000024)
            {
            }
            column(CompName;compInfo.Name)
            {
            }
            column(CompAddress;compInfo.Address)
            {
            }
            column(CompCity;compInfo.City)
            {
            }
            column(CompPhone;compInfo."Phone No.")
            {
            }
            column(CompMail;compInfo."E-Mail")
            {
            }
            column(CompWeb;compInfo."Home Page")
            {
            }
            column(Logo;compInfo.Picture)
            {
            }
            column(UserNames;UserName)
            {
            }
            column(CompPostCode;compInfo."Post Code")
            {
            }
            column(ReceiptNo;"Sales Shipment Header"."No.")
            {
            }
            column(PostingDate;"Sales Shipment Header"."Posting Date")
            {
            }
            column(AmPaid;"Sales Shipment Header"."Amount Paid")
            {
            }
            column(DocumentAmount;"Sales Shipment Header"."Document Amount")
            {
            }
            column(Balance;"Sales Shipment Header"."Amount Paid"-"Sales Shipment Header"."Document Amount")
            {
            }
            dataitem("Sales Shipment Line";"Sales Shipment Line")
            {
                DataItemLink = "Document No."=field("No.");
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(ItemNo;"Sales Shipment Line"."No.")
                {
                }
                column(ItemDesc;"Sales Shipment Line".Description)
                {
                }
                column(Qty;"Sales Shipment Line".Quantity)
                {
                }
                column(UnitPrice;"Sales Shipment Line"."Unit Price")
                {
                }
                column(LineAmount;"Sales Shipment Line"."Unit Price"*"Sales Shipment Line".Quantity)
                {
                }
                column(seq;seq)
                {
                }
                column(seq2;seq2)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                    seq2:=seq2+1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Sales Shipment Header".CalcFields("Sales Shipment Header"."Document Amount");
                seq:=0;
                Clear(UserName);
                Users.Reset;
                Users.SetRange(Users."User Name",UserId);
                if Users.Find('-') then begin
                    if Users."Full Name"<>'' then UserName:=Users."Full Name" else
                      UserName:=Users."User Name";
                  end;
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

    trigger OnInitReport()
    begin
        if compInfo.Get() then begin
          compInfo.CalcFields(Picture);
          end;
          Clear(seq);
          Clear(seq2);
    end;

    var
        compInfo: Record "Company Information";
        seq: Integer;
        datefilter: Text[30];
        seq2: Integer;
        Users: Record User;
        UserName: Text[130];
}

