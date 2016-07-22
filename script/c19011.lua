--半分幻的巫女✿东风谷早苗
function c19011.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0x497),aux.FilterBoolFunction(Card.IsSetCard,0x713),true)
		--奇跡☆
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19011,0))
		e1:SetCategory(CATEGORY_DICE+CATEGORY_RECOVER+CATEGORY_TODECK)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(c19011.cgcon)
		e1:SetTarget(c19011.target)
		e1:SetOperation(c19011.operation)
		c:RegisterEffect(e1)
		--分身の術
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DESTROY_REPLACE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c19011.desreptg)
		e2:SetOperation(c19011.desrepop)
		c:RegisterEffect(e2)

end


c19011.material_setcode=0x497


function c19011.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end


function c19011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end


function c19011.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	local d1,d2,d3,d4,d5=Duel.TossDice(tp,5)
	Duel.Recover(tp,(d1+d2+d3+d4+d5)*100,REASON_EFFECT)

	if d1==5 and ct>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end

	if d2==5 and ct>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end

	if d3==5 and ct>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end

	if d4==5 and ct>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end

	if d5==5 and ct>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end

end


function c19011.repfilter(c)
	return c:IsDestructable() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end


function c19011.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c19011.repfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local d=Duel.TossDice(tp,1)
	if d==4 or d==6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c19011.repfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		e:SetLabelObject(g:GetFirst())
		return true
	else return false end
end


function c19011.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end

