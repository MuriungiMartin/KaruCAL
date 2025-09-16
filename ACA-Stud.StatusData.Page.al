#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68017 "ACA-Stud. Status Data"
{
    PageType = List;
    SourceTable = UnknownTable61761;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("ID No.";"ID No.")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Title;Title)
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Sponsor Ref.";"Sponsor Ref.")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Relation";"NOK Relation")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Address";"NOK Address")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Email";"NOK Email")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Town";"NOK Town")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Phone";"NOK Phone")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Ext";"NOK Ext")
                {
                    ApplicationArea = Basic;
                }
                field("NOK Mobile";"NOK Mobile")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Reason";"Withdrawal Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Withdrawal Naration";"Withdrawal Naration")
                {
                    ApplicationArea = Basic;
                }
                field("Reinstate Note";"Reinstate Note")
                {
                    ApplicationArea = Basic;
                }
                field(Cleared;Cleared)
                {
                    ApplicationArea = Basic;
                }
                field("Discipline Status";"Discipline Status")
                {
                    ApplicationArea = Basic;
                }
                field(RegStud_Class;RegStud_Class)
                {
                    ApplicationArea = Basic;
                }
                field(RegCtudent_Cleared;RegCtudent_Cleared)
                {
                    ApplicationArea = Basic;
                }
                field(RegCtudent_Cleared_Date;RegCtudent_Cleared_Date)
                {
                    ApplicationArea = Basic;
                }
                field(RegStudent_Spons_Name;RegStudent_Spons_Name)
                {
                    ApplicationArea = Basic;
                }
                field(Sponsor_Address;Sponsor_Address)
                {
                    ApplicationArea = Basic;
                }
                field(Sponsor_Town;Sponsor_Town)
                {
                    ApplicationArea = Basic;
                }
                field(Sponsor_Email;Sponsor_Email)
                {
                    ApplicationArea = Basic;
                }
                field(Origin;Origin)
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
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = AddAction;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                       studBuffer.Reset;
                       if studBuffer.Find('-') then begin
                          repeat
                            begin
                              if cust.Get(studBuffer."Student No.") then begin
                                if (studBuffer.Cleared) then begin
                                  cust."Clearance Status":=cust."clearance status"::Cleared;
                                  if studBuffer.RegCtudent_Cleared_Date<>'' then begin
                                  //if Evaluate()
                                  end;
                                  if Evaluate(beginDate,studBuffer.RegStud_RegDate)  then begin
                                  end;
                                  if Evaluate(endDate,studBuffer.Course_End_Date) then begin
                                  end;
                                  if beginDate<>0D then begin
                                      cust."Admission Date":=beginDate;
                                  end;
                                  if endDate<>0D then begin
                                     cust."Programme End Date":=endDate;
                                  end;
                                  DimVal.Reset;
                                  DimVal.SetRange(DimVal."Dimension Code",'DEPARTMENT');
                                  DimVal.SetRange(DimVal.Code,studBuffer.RegStud_DeptID);
                                  if DimVal.Find('-') then
                                    cust."Global Dimension 2 Code":=studBuffer.RegStud_DeptID;
                                  cust.Modify;
                                end;
                              end;
                            end;
                          until studBuffer.Next=0;
                       end;
                end;
            }
            action("Create Withdrawal Reason")
            {
                ApplicationArea = Basic;
                Caption = 'Create Withdrawal Reason';
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                       studBuffer.Reset;
                       if studBuffer.Find('-') then begin
                        repeat
                          begin
                            if not (withdReasons.Get(studBuffer."Withdrawal Reason")) then begin
                              withdReasons.Init;
                              withdReasons."Withdraw Reason":=studBuffer."Withdrawal Reason";
                              withdReasons.Insert;
                            end;
                          end;
                        until studBuffer.Next=0;
                       end;
                end;
            }
            action("Update Student Status")
            {
                ApplicationArea = Basic;
                Caption = 'Update Student Status';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                       studBuffer.Reset;
                       if studBuffer.Find('-') then begin
                        repeat
                          begin
                            if (withdReasons.Get(studBuffer."Withdrawal Reason")) then begin
                            if ((withdReasons."Withdraw Reason"<>'') and (withdReasons."Withdraw Reason"<>'-')) then
                            if cust.Get(studBuffer."Student No.") then begin
                                cust.Status:=withdReasons.Status;
                                cust.Modify;
                            end;
                            end;
                          end;
                        until studBuffer.Next=0;
                       end;
                end;
            }
        }
    }

    var
        cust: Record Customer;
        studBuffer: Record UnknownRecord61761;
        beginDate: Date;
        endDate: Date;
        DimVal: Record "Dimension Value";
        withdReasons: Record UnknownRecord61010;
}

