#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70078 "Proc-Prequalification Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Proc-Prequalification Summary.rdlc';

    dataset
    {
        dataitem(proCY;UnknownTable60225)
        {
            RequestFilterFields = "Preq. Year","Preq. Category";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(PreqYear_proCY;proCY."Preq. Year")
            {
            }
            column(PreqCategory_proCY;proCY."Preq. Category")
            {
            }
            column(PrequalifiedSuppliers_proCY;proCY."Prequalified Suppliers")
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
            column(CompMail;CompanyInformation."E-Mail")
            {
            }
            column(CompUrl;CompanyInformation."Home Page")
            {
            }
            column(CompLogo;CompanyInformation.Picture)
            {
            }
            dataitem(suppCategory;UnknownTable60226)
            {
                DataItemLink = "Preq. Year"=field("Preq. Year"),"Preq. Category"=field("Preq. Category");
                column(ReportForNavId_1000000004; 1000000004)
                {
                }
                column(PreqYear_suppCategory;suppCategory."Preq. Year")
                {
                }
                column(PreqCategory_suppCategory;suppCategory."Preq. Category")
                {
                }
                column(SupplierCode_suppCategory;suppCategory.Supplier_Code)
                {
                }
                column(SupplierName_suppCategory;suppCategory."Supplier Name")
                {
                }
                column(Phone_suppCategory;suppCategory.Phone)
                {
                }
                column(Email_suppCategory;suppCategory.Email)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                proCY.CalcFields( "Prequalified Suppliers");
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
        CompanyInformation: Record "Company Information";
}

