#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51505 "Purchase Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Requisition.rdlc';

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(No_PurchaseHeader;"Purchase Header"."No.")
            {
            }
            column(PaytoName_PurchaseHeader;"Purchase Header"."Pay-to Name")
            {
            }
            column(PostingDescription_PurchaseHeader;"Purchase Header"."Posting Description")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeader;"Purchase Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeader;"Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            column(PostingDate_PurchaseHeader;"Purchase Header"."Posting Date")
            {
            }
            column(SugestedSupplierNo;"Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(SuggestedSuppName;"Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(BuyFromAddress;"Purchase Header"."Buy-from Address"+','+"Purchase Header"."Buy-from Address 2"+'-'+"Purchase Header"."Buy-from City")
            {
            }
            column(BuyFromContact;"Purchase Header"."Buy-from Post Code")
            {
            }
            column(Dept;"Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            column(ReqDate;"Purchase Header"."Requested Receipt Date")
            {
            }
            column(sign1;usersetup1."User Signature")
            {
            }
            column(sign2;usersetup2."User Signature")
            {
            }
            column(sign3;usersetup3."User Signature")
            {
            }
            column(sign4;usersetup4."User Signature")
            {
            }
            column(datetime1;signDate1)
            {
            }
            column(datetime2;signDate2)
            {
            }
            column(datetime3;signDate3)
            {
            }
            column(datetime4;signDate4)
            {
            }
            column(AppTitle1;usersetup1."Approval Title")
            {
            }
            column(AppTitle2;usersetup2."Approval Title")
            {
            }
            column(AppTitle3;usersetup3."Approval Title")
            {
            }
            column(AppTitle4;usersetup4."Approval Title")
            {
            }
            column(DptName;DptName)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone;CompanyInformation."Phone No.")
            {
            }
            column(Logo;CompanyInformation.Picture)
            {
            }
            column(CompMail;CompanyInformation."E-Mail")
            {
            }
            column(CompUrl;CompanyInformation."Home Page")
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                column(ReportForNavId_7; 7)
                {
                }
                column(Type_PurchaseLine;"Purchase Line".Type)
                {
                }
                column(No_PurchaseLine;"Purchase Line"."No.")
                {
                }
                column(Description_PurchaseLine;"Purchase Line".Description)
                {
                }
                column(UnitofMeasure_PurchaseLine;"Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine;"Purchase Line".Quantity)
                {
                }
                column(DirectUnitCost_PurchaseLine;"Purchase Line"."Direct Unit Cost")
                {
                }
                column(Amount_PurchaseLine;"Purchase Line".Amount)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                counted:=0;
                AppReq.Reset;
                AppReq.SetRange("Document No.","Purchase Header"."No.");
                AppReq.SetRange("Approved The Document",true);
                if AppReq.Find('-') then begin
                    repeat
                        begin
                        counted:=counted+1;
                        if counted=1 then begin
                          usersetup1.Reset;
                          usersetup1.SetRange(usersetup1."User ID",AppReq."Approver ID");
                          if usersetup1.Find('-') then begin
                            usersetup1.CalcFields("User Signature");
                            signDate1:=AppReq."Last Date-Time Modified";
                            end;
                          end else if counted=2 then begin
                                      usersetup2.Reset;
                          usersetup2.SetRange(usersetup2."User ID",AppReq."Approver ID");
                          if usersetup2.Find('-') then begin
                            usersetup2.CalcFields("User Signature");
                            signDate2:=AppReq."Last Date-Time Modified";
                            end;
                            end else if counted=3 then begin
                                        usersetup3.Reset;
                          usersetup3.SetRange(usersetup3."User ID",AppReq."Approver ID");
                          if usersetup3.Find('-') then begin
                            usersetup3.CalcFields("User Signature");
                            signDate3:=AppReq."Last Date-Time Modified";
                            end;
                              end else if counted=4 then begin
                                          usersetup4.Reset;
                          usersetup4.SetRange(usersetup4."User ID",AppReq."Approver ID");
                          if usersetup4.Find('-') then begin
                            usersetup4.CalcFields("User Signature");
                            signDate4:=AppReq."Last Date-Time Modified";
                            end;
                                end;

                        end;
                      until AppReq.Next=0;
                  end;

                DimValue.Reset;
                DimValue.SetRange(DimValue."Global Dimension No.",2);
                DimValue.SetRange(Code, "Purchase Header"."Shortcut Dimension 2 Code");
                if DimValue.Find('-') then
                  DptName:= DimValue.Name;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get;
                CompanyInformation.CalcFields(Picture);
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
        AppReq: Record "Approval Entry";
        counted: Integer;
        usersetup1: Record "User Setup";
        usersetup2: Record "User Setup";
        usersetup3: Record "User Setup";
        usersetup4: Record "User Setup";
        signDate1: DateTime;
        signDate2: DateTime;
        signDate3: DateTime;
        signDate4: DateTime;
        DptName: Text;
        DimValue: Record "Dimension Value";
        CompanyInformation: Record "Company Information";
}

