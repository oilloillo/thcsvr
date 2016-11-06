--混沌翼之恶灵✿魅魔
function c12026.initial_effect(c)
	--true light material
	Fus.AddFusionProcFun2(c,c12026.mfilter1,c12026.mfilter2,true)
	c:EnableReviveLimit()
	--deep dark remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12026,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c12026.descost)
	e1:SetCondition(c12026.descon)
	e1:SetTarget(c12026.destg)
	e1:SetOperation(c12026.desop)
	c:RegisterEffect(e1)
	--deep dark return
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(12026,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12026.target)
	e2:SetOperation(c12026.returng)
	c:RegisterEffect(e2)
	--world forger
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetCondition(c12026.atkcon)
	e3:SetValue(c12026.atkval)
	c:RegisterEffect(e3)
end
function c12026.mfilter1(c)
	return c:IsFusionSetCard(0x208) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO)
end
function c12026.mfilter2(c)
	return c:IsFusionSetCard(0x208) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
end
function c12026.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c12026.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsAttribute(ATTRIBUTE_DARK) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c12026.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function c12026.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12026.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c12026.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c12026.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c12026.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c12026.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c12026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12026.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12026,2))
	local g=Duel.SelectTarget(tp,c12026.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c12026.returng(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		if tc:GetAttribute()==ATTRIBUTE_LIGHT then
			Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
		elseif tc:GetAttribute()==ATTRIBUTE_DARK then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(1500)
			e:GetHandler():RegisterEffect(e2)
		end
	end
end
function c12026.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	if a==c then a=Duel.GetAttackTarget() end
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and a and a:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsRelateToBattle()
end
function c12026.atkval(e,c)
	return e:GetHandler():GetAttack()*2
end
