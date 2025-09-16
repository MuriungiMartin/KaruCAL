#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69271 "Meal Booking Form"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Meal Booking Form.rdlc';

    dataset
    {
        dataitem(UnknownTable61778;UnknownTable61778)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompName;info.Name)
            {
            }
            column(Address1;info.Address)
            {
            }
            column(Address2;info."Address 2")
            {
            }
            column(City;info.City)
            {
            }
            column(Phone1;info."Phone No.")
            {
            }
            column(Phone2;info."Phone No. 2")
            {
            }
            column(Fax;info."Fax No.")
            {
            }
            column(Pic;info.Picture)
            {
            }
            column(postCode;info."Post Code")
            {
            }
            column(CompEmail;info."E-Mail")
            {
            }
            column(HomePage;info."Home Page")
            {
            }
            column(DocNo;"CAT-Meal Booking Header"."Booking Id")
            {
            }
            column(DeptCode;"CAT-Meal Booking Header".Department)
            {
            }
            column(DeptName;"CAT-Meal Booking Header"."Department Name")
            {
            }
            column(reqBy;"CAT-Meal Booking Header"."Requested By")
            {
            }
            column(ReqDate;"CAT-Meal Booking Header"."Request Date")
            {
            }
            column(BooKdate;"CAT-Meal Booking Header"."Booking Date")
            {
            }
            column(BookTime;"CAT-Meal Booking Header"."Booking Time")
            {
            }
            column(ReqTime;"CAT-Meal Booking Header"."Required Time")
            {
            }
            column(MeetingName;"CAT-Meal Booking Header"."Meeting Name")
            {
            }
            column(Venue;"CAT-Meal Booking Header".Venue)
            {
            }
            column(ContactPerson;"CAT-Meal Booking Header"."Contact Person")
            {
            }
            column(ContactNumber;"CAT-Meal Booking Header"."Contact Number")
            {
            }
            column(ContactMail;"CAT-Meal Booking Header"."Contact Mail")
            {
            }
            column(Pax;"CAT-Meal Booking Header".Pax)
            {
            }
            column(Status;"CAT-Meal Booking Header".Status)
            {
            }
            column(TotalCost;"CAT-Meal Booking Header"."Total Cost")
            {
            }
            dataitem(UnknownTable61779;UnknownTable61779)
            {
                DataItemLink = "Booking Id"=field("Booking Id");
                DataItemTableView = where("Line No."=filter(<>0));
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(BkID;"CAT-Meal Booking Lines"."Booking Id")
                {
                }
                column(LineNo;"CAT-Meal Booking Lines"."Line No.")
                {
                }
                column(MealCode;"CAT-Meal Booking Lines"."Meal Code")
                {
                }
                column(MealName;"CAT-Meal Booking Lines"."Meal Name")
                {
                }
                column(Quantity;"CAT-Meal Booking Lines".Quantity)
                {
                }
                column(UnitPrice;"CAT-Meal Booking Lines"."Unit Price")
                {
                }
                column(Cost;"CAT-Meal Booking Lines".Cost)
                {
                }
                column(Price;"CAT-Meal Booking Lines".Price)
                {
                }
                column(Remarks;"CAT-Meal Booking Lines".Remarks)
                {
                }
            }
            dataitem("Approval Entry";"Approval Entry")
            {
                DataItemLink = "Document No."=field("Booking Id");
                DataItemTableView = sorting("Table ID","Document Type","Document No.","Sequence No.","Approver ID") order(ascending) where(Status=filter(Approved),"Approved The Document"=filter(true));
                column(ReportForNavId_1000000036; 1000000036)
                {
                }
                column(DateAndTime;"Approval Entry"."Last Date-Time Modified")
                {
                }
                column(ApproverId;"Approval Entry"."Approver ID")
                {
                }
                column(Title;userSetup6."Approval Title")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    userSetup6.Reset;
                    userSetup6.SetRange("User ID","Approval Entry"."Approver ID");
                    if userSetup6.Find('-') then begin

                      end;
                end;
            }
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

    trigger OnPreReport()
    begin
        if info.Get() then begin
            info.CalcFields(Picture);
          end;
    end;

    var
        info: Record "Company Information";
        userSetup: Record "User Setup";
        userSetup1: Record "User Setup";
        userSetup2: Record "User Setup";
        userSetup3: Record "User Setup";
        userSetup4: Record "User Setup";
        userSetup5: Record "User Setup";
        userSetup6: Record "User Setup";
}

