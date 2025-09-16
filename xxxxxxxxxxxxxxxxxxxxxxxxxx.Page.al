#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68018 xxxxxxxxxxxxxxxxxxxxxxxxxx
{
    PageType = List;
    SourceTable = UnknownTable61762;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Course Name";"Course Name")
                {
                    ApplicationArea = Basic;
                }
                field("Course Access Code";"Course Access Code")
                {
                    ApplicationArea = Basic;
                }
                field("Prog. Code";"Prog. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. No";"Reg. No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Update Data")
            {
                ApplicationArea = Basic;
                Caption = 'Update Data';

                trigger OnAction()
                begin
                           stdWithCodes.Reset;
                           cust.Reset;
                           dimVal.Reset;
                           if stdWithCodes.Find('-') then begin
                            begin
                              repeat
                                begin
                                  if cust.Get(stdWithCodes."Reg. No") then begin
                                  dimVal.Reset;
                                  dimVal.SetRange(dimVal."Dimension Code",'DEPARTMENT');
                                    if Prog.Get(stdWithCodes."Prog. Code") then begin
                                    if dimVal.Find('-') then begin
                                      Prog."Department Code":=dimVal.Code;
                                      Prog.Modify;
                                    end;
                                    end;
                                      cust."Admission Date":=stdWithCodes."Start Date";
                                      cust."Arrival Date":=stdWithCodes."Start Date";
                                      cust."Class Code":=stdWithCodes."Course Access Code";
                                      cust."Programme End Date" :=stdWithCodes."End Date";
                                      cust."Current Programme":=stdWithCodes."Prog. Code";
                                      cust."Global Dimension 2 Code":=dimVal.Code;
                                      cust.Modify;

                                  end;
                                end;
                              until stdWithCodes.Next=0;
                            end;
                           end;
                end;
            }
        }
    }

    var
        stdWithCodes: Record UnknownRecord61762;
        cust: Record Customer;
        dimVal: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
}

