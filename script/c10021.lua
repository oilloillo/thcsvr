 
--本居小铃
function c10021.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x208),2,2)
	c:EnableReviveLimit()
	--pos&def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10021,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c10021.cost)
	e1:SetTarget(c10021.postg)
	e1:SetOperation(c10021.posop)
	c:RegisterEffect(e1)
	--arrange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10021,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10021.cost1)
	e2:SetTarget(c10021.target)
	e2:SetOperation(c10021.activate)
	c:RegisterEffect(e2)
end
function c10021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10021.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return e:GetHandler():GetFlagEffect(10021)==0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(10021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10021.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENCE)
			e1:SetValue(-800)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
function c10021.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10021)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,10021,RESET_PHASE+PHASE_END,0,1)
end
function c10021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(10021)==0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RegisterFlagEffect(10021,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c10021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,3)
end
