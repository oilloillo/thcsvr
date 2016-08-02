--奇迹之魔女-贝伦卡斯泰露
function c501101.initial_effect(c)
	aux.AddXyzProcedure(c,nil,5,2,c501101.ovfilter,aux.Stringid(501101,1))
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(501101,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c501101.cost)
	e1:SetTarget(c501101.destg)
	e1:SetOperation(c501101.desop)
	c:RegisterEffect(e1)
end
function c501101.ovfilter(c)
	return c:IsFaceup() and c:IsCode(501102)
end
function c501101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c501101.filter(c)
	return  c:IsDestructable() and not (c:IsSetCard(0x811) and c:IsFaceup())
end
function c501101.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c501101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c501101.desop(e,tp,eg,ep,ev,re,r,rp)
	local r1,r2,r3=Duel.TossCoin(tp,3)
	if r1+r2+r3==3 then
		local g=Duel.GetMatchingGroup(c501101.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif r1+r2+r3==2 then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	else
	    Duel.Damage(tp,900,REASON_EFFECT)
	end
end