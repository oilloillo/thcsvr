 
--阳炎型驱逐舰-雪风
function c50011.initial_effect(c)
	local temp = 0
	while temp<6 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c50011.indcon)
	c:RegisterEffect(e2)
	--activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c50011.tgcon)
	e3:SetTarget(c50011.tgtg)
	e3:SetOperation(c50011.tgop)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50011.indcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end
function c50011.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc~=c or not c:IsLocation(LOCATION_MZONE) then return false end
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c50011.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c50011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chk==0 then return Duel.IsExistingTarget(c50011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c50011.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c50011.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
end
