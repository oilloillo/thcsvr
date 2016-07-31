 
--人类代表的魔法使
function c10004.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--eqiup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10004,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10004.eqcon)
	e1:SetTarget(c10004.eqtg)
	e1:SetOperation(c10004.eqop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c10004.val)
	c:RegisterEffect(e2)
end
function c10004.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c10004.filter(c,tp)
	return c:IsFacedown() and (c:IsLocation(LOCATION_SZONE) 
	or (c:IsLocation(LOCATION_MZONE) and c:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0))
end
function c10004.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnfield() and chkc:IsControler(1-tp) and c10004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10004.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c10004.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetChainLimit(c10004.chainlimit)
end
function c10004.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c10004.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10004.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,tc,c,false)
		local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10004.eqlimit)
			tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)	
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c10004.val(e,c)
	return c:GetEquipCount()*400
end
