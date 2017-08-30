--惜命「不死之身的舍身击」
function c7001201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7001201,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c7001201.cost)
	e1:SetTarget(c7001201.target)
	e1:SetOperation(c7001201.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7001201,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7001201+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(c7001201.descost)
	e2:SetTarget(c7001201.destg)
	e2:SetOperation(c7001201.desop)
	c:RegisterEffect(e2)
end
function c7001201.refilter(c)
	return c:IsSetCard(0x137)
end
function c7001201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c7001201.refilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c7001201.refilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c7001201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c7001201.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(tp,800,REASON_EFFECT)
end
function c7001201.filter(c)
	return c:IsCode(21024)
end
function c7001201.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c7001201.filter,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	local sg=Duel.SelectReleaseGroup(tp,c7001201.filter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c7001201.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c7001201.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Damage(1-tp,tc:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
