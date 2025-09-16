#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65211 "Lecturer Loading Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Lecturer Loading Invoice.rdlc';

    dataset
    {
        dataitem("Purch. Inv. Header";"Purch. Inv. Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Buy-from Vendor No.","No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Companyname;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompAddress1;CompanyInformation."Address 2")
            {
            }
            column(CompPhonenO;CompanyInformation."Phone No.")
            {
            }
            column(CompPhoneNo2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompPic;CompanyInformation.Picture)
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompHome;CompanyInformation."Home Page")
            {
            }
            column(InvNo;"Purch. Inv. Header"."No.")
            {
            }
            column(ShipCustNo;"Purch. Inv. Header"."Buy-from Vendor No.")
            {
            }
            column(ShipBill2No;"Purch. Inv. Header"."Pay-to Vendor No.")
            {
            }
            column(ShipBill2Name;"Purch. Inv. Header"."Pay-to Name")
            {
            }
            column(YourRef;"Purch. Inv. Header"."Your Reference")
            {
            }
            column(PostinDate;"Purch. Inv. Header"."Posting Date")
            {
            }
            column(PostingDes;"Purch. Inv. Header"."Posting Description")
            {
            }
            column(OrderNo;"Purch. Inv. Header"."Vendor Invoice No.")
            {
            }
            column(UserId1;"Purch. Inv. Header"."User ID")
            {
            }
            column(OrderRoute;'')
            {
            }
            column(route;'')
            {
            }
            column(PhoneNo;vendor."Phone No.")
            {
            }
            column(PrevBalance;vendor.Balance)
            {
            }
            column(BalAfterInvoice;vendor.Balance)
            {
            }
            column(invNo2;PurchaseInvoiceHeader."No.")
            {
            }
            column(invAmount;PurchaseInvoiceHeader.Amount)
            {
            }
            column(salesPerson;'')
            {
            }
            column(LocCode;'')
            {
            }
            dataitem("Purch. Inv. Line";"Purch. Inv. Line")
            {
                DataItemLink = "Document No."=field("No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(seq;seq)
                {
                }
                column(LineNo;"Purch. Inv. Line"."Line No.")
                {
                }
                column(ItemType;"Purch. Inv. Line".Type)
                {
                }
                column(ItemNo;"Purch. Inv. Line"."No.")
                {
                }
                column(ItemDesc;"Purch. Inv. Line".Description)
                {
                }
                column(UnitOdMeasure;MILKOrderCustProdSource."Unit Cost")
                {
                }
                column(ItemQty;"Purch. Inv. Line".Quantity)
                {
                }
                column(unitPrice;"Purch. Inv. Line"."Direct Unit Cost")
                {
                }
                column(amnt;"Purch. Inv. Line"."Direct Unit Cost")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    seq:=seq+1;
                    if Item.Get("Purch. Inv. Line"."No.") then begin
                      end;


                    MILKOrderBatchLines.Reset;
                    MILKOrderBatchLines.SetRange(MILKOrderBatchLines."PV No.","Purch. Inv. Header"."No.");
                    if MILKOrderBatchLines.Find('-') then begin
                      MILKOrderCustProdSource.Reset;
                      MILKOrderCustProdSource.SetRange(MILKOrderCustProdSource.Semester,MILKOrderBatchLines."Semester Code");
                      MILKOrderCustProdSource.SetRange(MILKOrderCustProdSource.Lecturer,"Purch. Inv. Header"."Buy-from Vendor No.");
                     // MILKOrderCustProdSource.SETRANGE(MILKOrderCustProdSource.Stage,"Sales Invoice Line"."No.");
                      if MILKOrderCustProdSource.Find('-') then begin
                        end;
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(seq);
                vendor.Reset;
                vendor.SetRange(vendor."No.","Purch. Inv. Header"."Buy-from Vendor No.");
                if vendor.Find('-') then begin
                 // Vendor.SETFILTER("Date Filter",'..%1',CALCDATE('-1D',"Sales Invoice Header"."Posting Date"));
                  vendor.CalcFields(Balance);
                  end;

                PurchaseInvoiceHeader.Reset;
                PurchaseInvoiceHeader.SetRange(PurchaseInvoiceHeader."No.","Purch. Inv. Header"."No.");
                if PurchaseInvoiceHeader.Find('-') then begin
                  PurchaseInvoiceHeader.CalcFields(PurchaseInvoiceHeader.Amount);
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
        if CompanyInformation.Get() then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    var
        CompanyInformation: Record "Company Information";
        seq: Integer;
        vendor: Record Vendor;
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        Item: Record Item;
        MILKOrderBatchLines: Record UnknownRecord65201;
        MILKOrderCustProdSource: Record UnknownRecord65202;
}

