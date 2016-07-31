 
--焰星「十凶星」
function c24036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24036.cost)
	e1:SetTarget(c24036.target)
	e1:SetOperation(c24036.activate)
	c:RegisterEffect(e1)
end
function c24036.costfilter(c)
	return c:IsSetCard(0x625) and c:GetAttack()>=2600
end
function c24036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24036.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c24036.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c24036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>1 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c24036.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local lc=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)
	local s=math.floor(lc/2)
	local d=s*1600
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end
